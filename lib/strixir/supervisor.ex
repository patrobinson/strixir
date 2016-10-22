defmodule Strixir.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    callback_module = Application.get_env(:strixir, :async_callback_module)
    callback_function = Application.get_env(:strixir, :async_callback_function)

    children = [
      worker(Strixir.RateLimiting, [RateLimiter]),
      worker(Strixir.AsyncRequests, [AsyncWorker])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
