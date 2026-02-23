---
---
# Customization

The actual HTTP requests are sent using [Finch](https://hexdocs.pm/finch/Finch.html). To customize the request (for example, to provide timeouts or proxy), add `:request_options` inside your `config.exs` file:

```elixir
config :elixir_lokalise_api,
  api_token: {:system, "LOKALISE_API_TOKEN"},
  request_options: [
    receive_timeout: 5_000,
    connect_timeout: 5_000
  ]
```

If the `request_options` is not provided, the default options will be utilized. You can find full list
of all the available `:options` in the Finch docs.

You can also override the default host URLs:

```elixir
config :elixir_lokalise_api, base_url_api: "YOUR_API_BASE_URL"
config :elixir_lokalise_api, base_url_oauth2: "YOUR_OAUTH2_BASE_URL"
```