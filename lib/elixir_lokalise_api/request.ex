defmodule ElixirLokaliseApi.Request do
  @moduledoc """
  Sends HTTP requests to the Lokalise APIv2
  """
  use HTTPoison.Base

  alias ElixirLokaliseApi.Config
  alias ElixirLokaliseApi.Processor
  alias ElixirLokaliseApi.UrlGenerator
  alias __MODULE__

  @defaults [
    type: nil,
    data: nil,
    url_params: Keyword.new(),
    query_params: Keyword.new(),
    for: :api
  ]

  @doc """
  Prepares and sends an HTTP request with the provided verb and options.
  """
  @spec do_request(method(), url(), Keyword.t()) ::
          {:ok, struct | map} | {:error, atom | String.t() | {map, integer}}
  def do_request(verb, module, opts) do
    opts = opts |> prepare_opts()

    request =
      Request.request(
        verb,
        UrlGenerator.generate(module, opts),
        Processor.encode(opts[:data]),
        headers(opts[:for]),
        request_params(opts[:query_params])
      )

    with {:ok, response} <- request,
         {:ok, parsed_result} <- Processor.parse(response, module, opts[:type]) do
      {:ok, parsed_result}
    else
      {:error, error} ->
        # HTTPoison error
        # coveralls-ignore-start
        {:error, error.reason}

      # coveralls-ignore-end

      {:error, data, status} ->
        # Processor error
        {:error, {data, status}}
    end
  end

  defp headers(:api) do
    opts = headers(:base)

    case Config.oauth2_token() do
      nil ->
        Keyword.merge(opts, "X-Api-Token": Config.api_token())

      token ->
        Keyword.merge(opts, Authorization: "Bearer #{token}")
    end
  end

  defp headers(_) do
    [
      Accept: "application/json",
      "User-Agent": "elixir-lokalise-api package/#{Config.version()}"
    ]
  end

  @spec request_params(Keyword.t()) :: Keyword.t()
  defp request_params(params), do: Keyword.merge(Config.request_options(), params: params)

  @spec prepare_opts(Keyword.t()) :: Keyword.t()
  defp prepare_opts(opts), do: Keyword.merge(@defaults, opts)
end
