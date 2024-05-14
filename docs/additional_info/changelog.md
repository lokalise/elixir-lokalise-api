# Changelog

## 3.1.0 (14-May-2024)

* Add support for [cursor pagination](https://lokalise.github.io/elixir-lokalise-api/api/getting-started#cursor-pagination) for List keys and List translation endpoints:

```elixir
{:ok, %KeysCollection{} = keys} = Keys.all(@project_id, limit: 2, pagination: "cursor", cursor: "eyIxIjozNzk3ODEzODh9")

keys.per_page_limit # => 2
keys.next_cursor # => "eyIxIjo0NTc4NDUxMDd9"
```

## 3.0.0 (02-Feb-2023)

* Elixir v1.14+ is required.
* Added new configuration options: `oauth2_client_id` and `oauth2_client_secret`. For example, you can say:

```elixir
config :elixir_lokalise_api, oauth2_client_id: {:system, "OAUTH_CLIENT_ID"}
```

* These new options are added to introduce [OAuth 2 flow](https://developers.lokalise.com/docs/oauth-2-flow). Now you can obtain OAuth 2 tokens and refresh them:

```elixir
# 1. Generate an authentication URL:

uri = ElixirLokaliseApi.OAuth2.Auth.auth(
  ["read_projects", "write_tasks"], # scopes
  "http://example.com/callback", # redirect uri
  "secret state" # state
)

# 2. The user should visit this URL. They'll be redirected to the callback along with a secret code.

# 3. Use the secret code to obtain an access token:

{:ok, response} = ElixirLokaliseApi.OAuth2.Auth.token("secret code")

response.access_token # => 123abc
response.refresh_token # => 345xyz

# 4. Use the refresh token to obtain a new access token:

{:ok, response} = ElixirLokaliseApi.OAuth2.Auth.refresh("OAUTH2_REFRESH_TOKEN")

response.access_token # => 789xyz
```

## 2.3.0 (28-Jul-2022)

* Added support for [Delete file endpoint](https://developers.lokalise.com/reference/delete-a-file):

```elixir
{:ok, %{} = resp} = Files.delete(project_id, file_id)

resp.file_deleted # => true
resp.project_id # => "123.abc"
```

* Fixed documentation links

## 2.2.0 (17-Dec-2021)

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