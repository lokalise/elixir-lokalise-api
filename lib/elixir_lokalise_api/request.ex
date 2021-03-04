defmodule ElixirLokaliseApi.Request do
  use HTTPoison.Base

  alias ElixirLokaliseApi.Config
  alias ElixirLokaliseApi.Parser
  alias __MODULE__

  def get(module, id \\ nil) do
    url = Config.base_url <> module.path_for(id)

    url
    |> String.replace_trailing("/", "")
    |> Request.get!(headers())
    |> Parser.parse(module)
  end

  def post(module, data \\ nil) do
    url = Config.base_url <> module.path_for()
    data = data |> Jason.encode!

    url
    |> String.replace_trailing("/", "")
    |> Request.post!(data, headers())
    |> Parser.parse(module)
  end

  defp headers() do
    [
      "X-Api-Token": Config.api_token,
      "Accept": "application/json",
      "User-Agent": "elixir-lokalise-api package/#{Config.version}"
    ]
  end
end
