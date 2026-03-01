---
---
# Exception handling

## Errors

[Error codes used by the API](https://developers.lokalise.com/reference/api-errors)

All API errors are returned in a 2-tuple form:

```elixir
{:error, reason}
```

The shape of reason depends on the type of failure.

### API errors (HTTP 4xx/5xx)

Returned when the Lokalise API responds with an error:

```elixir
{:error, {%{"error" => message}, status_code}}
```

Example:

```elixir
{:error, {%{"error" => "Unauthorized"}, 401}}
```

### Transport / network errors

Returned when the request fails before reaching the API (Finch/Mint errors):

```elixir
{:error, :timeout}
{:error, :nxdomain}
{:error, :closed}
{:error, "TLS handshake failure"}
```

### Generic catch-all

Any unexpected error shape is returned as:

```elixir
{:error, other}
```

### Sample handling pattern

```elixir
case ElixirLokaliseApi.Projects.find(project_id) do
  {:ok, data} ->
    IO.inspect(data)

  # API error with body and status
  {:error, {err_map, status}} ->
    IO.inspect(err_map)
    IO.inspect(status)

  # Transport-level error (atom or string)
  {:error, reason} ->
    IO.inspect(reason)
end
```

## API Rate Limits

[Access to all endpoints is limited](https://developers.lokalise.com/reference/api-rate-limits) to 6 requests per second from 14 September, 2021. This limit is applied per API token and per IP address. If you exceed the limit, a 429 HTTP status code will be returned and the corresponding exception will be raised that you should handle properly. To handle such errors, we recommend an exponential backoff mechanism with a limited number of retries.

Only one concurrent request per token is allowed.
