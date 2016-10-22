use Mix.Config

config :strixir,
  http_client: HTTPoison,
  callback_module: IO,
  callback_function: "inspect"

config :logger,
  backends: [:console],
  compile_time_purge_level: :debug