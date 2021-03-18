defmodule ElixirLokaliseApi.Request do
  @moduledoc """
  Sends HTTP requests to the Lokalise APIv2
  """
  use HTTPoison.Base

  alias ElixirLokaliseApi.Config
  alias ElixirLokaliseApi.Processor
  alias ElixirLokaliseApi.UrlGenerator
  alias __MODULE__

  @defaults [type: nil, data: nil, url_params: Keyword.new(), query_params: Keyword.new()]

  @doc """
  Prepares and sends an HTTP request with the provided verb and options
  """
  def do_request(verb, module, opts) do
    opts = opts |> prepare_opts()

    Request.request!(
      verb,
      UrlGenerator.generate(module, opts),
      Processor.encode(opts[:data]),
      headers(),
      request_params(opts[:query_params])
    )
    |> Processor.parse(module, opts[:type])
  end

  defp headers() do
    [
      "X-Api-Token": Config.api_token(),
      Accept: "application/json",
      "User-Agent": "elixir-lokalise-api package/#{Config.version()}"
    ]
  end

  defp request_params(params), do: Keyword.merge(Config.request_options(), params: params)

  defp prepare_opts(opts), do: Keyword.merge(@defaults, opts)
end
