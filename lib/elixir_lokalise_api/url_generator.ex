defmodule ElixirLokaliseApi.UrlGenerator do
  @moduledoc """
  Generates full URLs for the API endpoints
  """
  alias ElixirLokaliseApi.Config

  @re_placeholder ~r/{(!{0,1}):(\w*)}/

  @doc """
  Returns full URL based on the endpoint path template
  """
  @spec generate(module(), Keyword.t()) :: String.t()
  def generate(module, opts) do
    module.endpoint()
    |> format(opts[:url_params])
    |> remove_double_slashes()
    |> full_url(opts[:for])
    |> clean()
  end

  defp format(string, nil), do: format(string, [])

  defp format(string, params) do
    Regex.replace(@re_placeholder, string, fn _, required, param ->
      case fetch_param(params, param) do
        nil when required == "!" -> raise("Required param #{param} is missing!")
        nil -> ""
        value -> to_string(value)
      end
    end)
  end

  defp fetch_param(params, key_str) do
    cond do
      is_list(params) ->
        atom_key =
          try do
            String.to_existing_atom(key_str)
          rescue
            ArgumentError -> nil
          end

        case atom_key do
          nil -> Keyword.get(params, String.to_atom(key_str))
          k -> Keyword.get(params, k)
        end

      is_map(params) ->
        Map.get(params, key_str) ||
          try do
            Map.get(params, String.to_existing_atom(key_str))
          rescue
            ArgumentError -> nil
          end

      true ->
        nil
    end
  end

  defp full_url(path, url_for), do: Config.base_url(url_for) <> path

  defp clean(url), do: url |> String.replace_trailing("/", "")

  defp remove_double_slashes(path), do: Regex.replace(~r/\/{2,}/, path, "/")
end
