import Config

config :elixir_lokalise_api,
  http_client: ElixirLokaliseApi.HTTPClient.FinchImpl

import_config "#{Mix.env()}.exs"
