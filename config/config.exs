import Config

alias ElixirLokaliseApi.HTTPClient.FinchImpl

config :elixir_lokalise_api,
  http_client: FinchImpl

import_config "#{Mix.env()}.exs"
