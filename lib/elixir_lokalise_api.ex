defmodule ElixirLokaliseApi do
  @moduledoc """
  `ElixirLokaliseApi` is an official client (interface) for the Lokalise APIv2.

  Learn more about Lokalise API at
  [https://developers.lokalise.com/reference/lokalise-rest-api](https://developers.lokalise.com/reference/lokalise-rest-api).

  To get started, you will need an API token that can be generated in your
  Lokalise profile.

  This token should be stored in your config file, for example `dev.exs`:

      config :elixir_lokalise_api, api_token: {:system, "LOKALISE_API_TOKEN"}

  Next, use one of the endpoints to send requests, for example:

      {:ok, project} = ElixirLokaliseApi.Projects.find("123.abc")
  """
end
