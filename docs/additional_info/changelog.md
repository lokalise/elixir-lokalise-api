# Changelog

## 2.2.0

* Added experimental support for API tokens obtained via OAuth 2 workflow. To use such tokens:

```elixir
config :elixir_lokalise_api, oauth2_token: "YOUR_API_OAUTH2_TOKEN"
```

* You can also provide OAuth 2 tokens dynamically:

```elixir
:oauth2_token |> ElixirLokaliseApi.Config.put_env(oauth2_token)
```

* Added [`TeamUserBillingDetails` endpoint](https://lokalise.github.io/elixir-lokalise-api/api/team-user-billing-details)
* Added [`Segments` endpoint](https://lokalise.github.io/elixir-lokalise-api/api/segments)

## 2.1.0 (27-Sep-2021)

* Prevent HTTPoison from leaking errors to higher modules (thanks, @dragonwasrobot).
* Fixed docs (thanks, @kianmeng).

## 2.0.0 (20-Sep-2021)

* Reworked configuration (thanks, @dragonwasrobot). Instead of saying `config :your_app, api_token: "LOKALISE_API_TOKEN"`, you should now provide config in the following way:

```elixir
config :elixir_lokalise_api, api_token: "LOKALISE_API_TOKEN"

# OR

config :elixir_lokalise_api, api_token: {:system, "ENV_VARIABLE_NAME"} # for env variables
```

## 1.0.0

* First stable release
* Added ability to provide `:request_options` inside the `config.exs`, for example:

```elixir
config :elixir_lokalise_api,
  api_token: {:system, "LOKALISE_API_TOKEN"},
  request_options: [
    timeout: 5000,
    recv_timeout: 5000
  ]
```

## 1.0.0-rc.1 (18-Mar-2021)

* Initial release