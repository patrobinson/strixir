use Mix.Config

config :strixir,
  http_client: Strixir.HTTPoison.InMemory,
  callback_module: Strixir.AsyncProcessor,
  callback_function: "process"

config :logger,
  backends: [:console],
  compile_time_purge_level: :debug