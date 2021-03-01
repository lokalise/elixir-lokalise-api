defmodule ElixirLokaliseApi.Request do
  use HTTPoison.Base

  alias ElixirLokaliseApi.Config
  alias ElixirLokaliseApi.Parser
  alias __MODULE__

  def get() do
    url = Config.base_url <> "projects?limit=1"
    headers = [
      "X-Api-Token": Config.api_token,
      "Accept": "application/json",
      "User-Agent": "elixir-lokalise-api package/#{Config.version}"
    ]
    url
    |> Request.get!(headers)
    |> Parser.parse
  end
end
