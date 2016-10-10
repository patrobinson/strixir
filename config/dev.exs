use Mix.Config

config :strixir, :http_client, HTTPoison

config :logger,
  backends: [:console],
  compile_time_purge_level: :debug
