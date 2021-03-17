defmodule ElixirLokaliseApi.UrlGenerator do
  @moduledoc """
  Generates full URLs for the API endpoints
  """
  alias ElixirLokaliseApi.Config

  @doc """
  Returns full URL based on the endpoint path template
  """
  def generate(module, opts) do
    module.endpoint()
    |> format(opts[:url_params])
    |> remove_double_slashes()
    |> full_url()
    |> clean()
  end

  defp format(string, nil), do: format(string, [])

  defp format(string, params) do
    Regex.replace(~r/{(!{0,1}):(\w*)}/, string, fn _, required, param ->
      case params[String.to_atom(param)] do
        nil when required == "!" -> raise("Reqired param #{param} is missing!")
        nil -> ""
        value -> to_string(value)
      end
    end)
  end

  defp full_url(path), do: Config.base_url() <> path

  defp clean(url), do: url |> String.replace_trailing("/", "")

  defp remove_double_slashes(path), do: Regex.replace(~r/\/{2,}/, path, "/")
end
