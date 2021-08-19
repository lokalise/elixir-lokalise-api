# Exception handling

## Error codes

[Error codes used by the API](https://app.lokalise.com/api2docs/curl/#resource-errors)

If an error is raised by the API, a tuple with three elements will be returned:

```elixir
{:error, error_data, http_status_code}
```

For example, you may use the following approach:

```elixir
case ElixirLokaliseApi.Projects.find(project_id) do
  {:ok, data} ->
    data |> IO.inspect

  {:error, error_data, http_status_code} ->
    error_data |> IO.inspect
    http_status_code |> IO.inspect
end
```

## API Rate Limits

[Access to all endpoints is limited](https://app.lokalise.com/api2docs/curl/#resource-rate-limits) to 6 requests per second from 14 September, 2021. This limit is applied per API token and per IP address. If you exceed the limit, a 429 HTTP status code will be returned and the corresponding exception will be raised that you should handle properly. To handle such errors, we recommend an exponential backoff mechanism with a limited number of retries.

Only one concurrent request per token is allowed.
