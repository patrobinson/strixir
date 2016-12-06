defmodule Strixir.AsyncRequests do
  use GenServer
  require Logger

  def start_link(_) do
    Logger.debug "Starting AsyncRequests"
    {:ok,_pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def work do
    GenServer.call(__MODULE__, :work)
  end

  def handle_call(:work, _from, state) do
    case Strixir.RateLimiting.pop_request do
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
