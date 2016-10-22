defmodule Strixir.AsyncRequests do
  import Strixir
  use GenServer
  require Logger

  def start_link(name) do
    Logger.debug "Starting AsyncRequests"
    GenServer.start_link(__MODULE__, name: name)
  end

  def work(pid) do
    GenServer.call(pid, {:work})
  end

  def handle_call({:work}, state) do
    case GenServer.call(RateLimiter, :pop_request) do
      [method, request_url, body, headers] ->
        Logger.debug "Processing request #{request_url}"
        {"page", page} = URI.parse(request_url).query |> Enum.to_list() |> List.keyfind("page", 0)
        {:reply, Strixir.json_request(method, request_url, body, headers), state}
      _ ->
        Logger.debug "No request to process"
        {:reply, nil, state}
    end
  end
end
