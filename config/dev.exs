import Config

config :elixir_lokalise_api,
  api_token: {:system, "LOKALISE_API_TOKEN"},
  oauth2_client_id: {:system, "OAUTH2_CLIENT_ID"},
  oauth2_client_secret: {:system, "OAUTH2_CLIENT_SECRET"},
  base_url_api: {:system, "LOKALISE_API_BASE_URL"},
  base_url_oauth2: {:system, "LOKALISE_OAUTH2_BASE_URL"}
