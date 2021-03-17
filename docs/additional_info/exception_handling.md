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

Lokalise does not [rate-limit API requests](https://app.lokalise.com/api2docs/curl/#resource-rate-limits), however retain a right to decline the service in case of excessive use. Only one concurrent request per token is allowed. To ensure data consistency, it is not recommended to access the same project simultaneously using multiple tokens.
