import Config

config :elixir_lokalise_api,
  api_token: "fake_token",
  oauth2_client_id: {:system, "OAUTH2_CLIENT_ID"},
  oauth2_client_secret: {:system, "OAUTH2_CLIENT_SECRET"},
  http_client: ElixirLokaliseApi.HTTPClientMock,
  request_options: [
    receive_timeout: 5_000,
    connect_timeout: 5_000
  ]

config :logger, level: :info
