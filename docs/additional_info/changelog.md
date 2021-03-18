# Changelog

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