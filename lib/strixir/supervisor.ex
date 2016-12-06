defmodule Strixir.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Strixir.RateLimiting, [Strixir.RateLimiting]),
      worker(Strixir.AsyncRequests, [Strixir.AsyncRequests])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
