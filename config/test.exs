import Config

config :elixir_lokalise_api,
  api_token: "LOKALISE_API_TOKEN",
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
  filter_request_headers: ["X-Api-Token"],
  match_requests_on: [:query, :request_body]
