use Mix.Config

config :elixir_lokalise_api,
  api_token: {:system, "LOKALISE_API_TOKEN"}

config :logger, level: :info

config :exvcr, [
  global_mock: true,
  vcr_cassette_library_dir: "test/fixtures/cassettes",
  custom_cassette_library_dir: "test/fixtures/cassettes",
  filter_url_params: false,
  filter_request_headers: ["X-Api-Token"],
  match_requests_on: [:query, :request_body]
]
