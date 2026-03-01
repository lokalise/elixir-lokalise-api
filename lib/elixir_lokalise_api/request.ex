defmodule ElixirLokaliseApi.Request do
  @moduledoc """
  Sends HTTP requests to the Lokalise APIv2
  """

  alias ElixirLokaliseApi.Config
  alias ElixirLokaliseApi.Processor
  alias ElixirLokaliseApi.UrlGenerator

  @defaults [
    type: nil,
    data: nil,
    url_params: [],
    query_params: [],
    for: :api
  ]

  @finch ElixirLokaliseApi.Finch

  @type method :: :get | :post | :put | :patch | :delete | :head | :options

  @spec do_request(method(), module(), Keyword.t()) ::
          {:ok, struct() | map()} | {:error, atom() | String.t() | {map(), non_neg_integer()}}
  def do_request(verb, module, opts) do
    opts = prepare_opts(opts)

    url =
      module
      |> UrlGenerator.generate(opts)
      |> add_query_params(opts[:query_params])

    body = Processor.encode(opts[:data])
    headers = build_headers(opts[:for]) |> maybe_add_json_content_type(body)

    request = Finch.build(verb, url, headers, body)

    with {:ok, response} <-
           Config.http_client().request(request, @finch, Config.request_options()),
         {:ok, parsed} <- Processor.parse(response, module, opts[:type]) do
      {:ok, parsed}
    else
      {:error, %Mint.TransportError{} = err} ->
        {:error, err.reason}

      {:error, %Mint.HTTPError{} = err} ->
        {:error, err.reason}

      {:error, %Finch.Error{} = err} ->
        {:error, err.reason}

      {:error, data, status} ->
        {:error, {data, status}}

      {:error, other} ->
        {:error, other}
    end
  end

  @doc false
  def maybe_add_json_content_type(headers, body)
      when is_binary(body) and byte_size(body) > 0 do
    if Enum.any?(headers, fn {k, _} -> String.downcase(k) == "content-type" end) do
      headers
    else
      [{"content-type", "application/json"} | headers]
    end
  end

  @doc false
  def maybe_add_json_content_type(headers, _body), do: headers

  # -------------------------
  # Query params
  # -------------------------

  defp add_query_params(url, []), do: url

  defp add_query_params(url, params) when is_list(params) do
    uri = URI.parse(url)

    new_query =
      params
      |> Enum.map(fn {k, v} -> {to_string(k), to_string(v)} end)

    existing =
      case uri.query do
        nil -> []
        q -> URI.decode_query(q) |> Map.to_list()
      end

    merged = existing ++ new_query

    %{uri | query: URI.encode_query(merged)}
    |> URI.to_string()
  end

  defp build_headers(:api) do
    base = build_headers(:base)

    case Config.oauth2_token() do
      token when is_binary(token) and byte_size(token) > 0 ->
        [{"authorization", "Bearer #{token}"} | base]

      _ ->
        [{"x-api-token", Config.api_token()} | base]
    end
  end

  defp build_headers(_) do
    [
      {"accept", "application/json"},
      {"user-agent", "elixir-lokalise-api package/#{Config.version()}"}
    ]
  end

  defp prepare_opts(opts), do: Keyword.merge(@defaults, opts)
end
