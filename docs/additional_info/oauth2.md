# OAuth 2

## Setting up the client

Lokalise also provides [OAuth 2 authentication flow](https://developers.lokalise.com/docs/oauth-2-flow). Let's see how to generate an OAuth 2 token. The obtained token can be used to perform API requests on behalf of a user.

First of all, you'll need to provide client id and client secret:

```elixir
config :elixir_lokalise_api, oauth2_client_id: "YOUR_CLIENT_ID", oauth2_client_secret: "YOUR_CLIENT_SECRET"
```

## Generating auth URL

Next, generate an authentication URL:

```elixir
uri = ElixirLokaliseApi.OAuth2.Auth.auth(
  ["read_projects", "write_tasks"], # scopes
  "http://example.com/callback", # redirect uri
  "secret state" # state
)
```

* `scope` is a required argument containing a required scopes list.
* `redirect_uri` is optional.
* `state` is optional as well: it can be used to prevent CSRF attacks.

The `auth` function returns a URL looking like this:

```
https://app.lokalise.com/oauth2/auth?client_id=12345&scope=read_projects
```

Your customers have to visit this URL and allow access to proceed. After allowing access, the customer will be presented with a secret code that has to be used in the following step.

## Generating OAuth 2 token

Next, call the `token` function and pass a secret code obtained on the previous step:

```elixir
{:ok, response} = ElixirLokaliseApi.OAuth2.Auth.token("secret code")
```

The `response` has the following attributes:

* `access_token` — your OAuth 2 token that can be used to send requests on the user's behalf.
* `refresh_token` — use this token to refresh an expired access token.
* `expires_in` — access token lifespan.
* `token_type` — access token type (usually, "Bearer").

## Refreshing OAuth 2 token

Once your access token expires, you can refresh it in the following way:

```elixir
{:ok, response} = ElixirLokaliseApi.OAuth2.Auth.refresh("OAUTH2_REFRESH_TOKEN")
```

The `response` has the following attributes:

* `access_token` — your new OAuth 2 token.
* `expires_in` — access token lifespan.
* `token_type` — access token type (usually, "Bearer").
* `scope` — your token scope.