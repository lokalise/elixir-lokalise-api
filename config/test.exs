import Config

config :elixir_lokalise_api,
  api_token: {:system, "LOKALISE_API_TOKEN"},
  oauth2_client_id: {:system, "OAUTH2_CLIENT_ID"},
  oauth2_client_secret: {:system, "OAUTH2_CLIENT_SECRET"},
  request_options: [
    timeout: 5000,
    recv_timeout: 5000
  ]

config :logger, level: :info

config :exvcr,
  global_mock: true,
  vcr_cassette_library_dir: "test/fixtures/cassettes",
  custom_cassette_library_dir: "test/fixtures/cassettes",
  filter_url_params: false,
  filter_request_headers: ["X-Api-Token", "Authorization"],
  filter_sensitive_data: [
    [pattern: System.get_env("OAUTH2_CLIENT_SECRET"), placeholder: "client_secret"],
    [pattern: System.get_env("OAUTH2_CLIENT_ID"), placeholder: "client_id"],
    [pattern: System.get_env("OAUTH2_REFRESH_TOKEN"), placeholder: "refresh"]
  ],
  match_requests_on: [:query, :request_body]
