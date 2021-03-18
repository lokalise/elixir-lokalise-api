# Customization

The actual HTTP requests are sent using [HTTPoison](https://github.com/edgurgel/httpoison).
To customize the request (for example, to provide timeouts or proxy), add `:request_options` inside your `config.exs` file:

```elixir
config :elixir_lokalise_api,
  api_token: {:system, "LOKALISE_API_TOKEN"},
  request_options: [
    timeout: 5000,
    recv_timeout: 5000
  ]
```

If the `request_options` is not provided, the default options will be utilized. You can find full list
of all the available `:options` in the [HTTPoison docs](https://hexdocs.pm/httpoison/HTTPoison.Request.html).