defmodule Strixir.RateLimiting do
  use GenServer
  require Logger

  # Described in https://strava.github.io/api/#rate-limiting
  @fifteen_minute_limit 600
  @daily_limit 30_000

  defstruct fifteen_start: 0, fifteen_count: 0, day_start: 0, day_count: 0, requests: []

  def start_link(name) do
    Logger.debug "Starting RateLimiting"
    {:ok,_pid} = GenServer.start_link(__MODULE__, %Strixir.RateLimiting{}, name: name)
  end

  def queue_request(pid, request_args) do
    GenServer.cast(pid, {:push, request_args})
  end

  def pop_request(pid),
  do: GenServer.call(pid, :pop)

  # Internal implementation

  def handle_call(:pop, _from, state = %Strixir.RateLimiting{fifteen_start: _, fifteen_count: _, day_start: _, day_count: _, requests: []}) do
    {:reply, nil, state}
  end

  def handle_call(:pop, _from, %Strixir.RateLimiting{fifteen_start: fs, fifteen_count: fc, day_start: ds, day_count: dc, requests: [h | t]}) do
    now = :os.system_time(:seconds)
    new_fs = case (fs + 900) < now do
      true -> now
      false -> fs
    end

    new_ds = case (ds + 86400) < now do
      true -> now
      false -> ds
    end
    sleep_time = cond do
      new_fs == now -> 0
      new_ds == now -> 0
      fc < @fifteen_minute_limit && dc < @daily_limit ->
        0
      dc > @daily_limit ->
        :os.system_time(:seconds) - ds
      fc > @fifteen_minute_limit ->
        :os.system_time(:seconds) - fs
    end
    :timer.sleep(sleep_time * 1000)
    new_fc = fc + 1
    new_dc = dc + 1
    {:reply, h, %Strixir.RateLimiting{fifteen_start: new_fs, fifteen_count: new_fc, day_start: new_ds, day_count: new_dc, requests: t}}
  end

  def handle_cast({:push, request_args}, state),
  do: { :noreply, [request_args | state] }
end
