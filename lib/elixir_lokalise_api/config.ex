defmodule ElixirLokaliseApi.Config do
  @moduledoc """
  Stores configuration variables used to communicate with Lokalise APIv2.
  All settings also accept `{:system, "ENV_VAR_NAME"}` to read their
  values from environment variables at runtime.
  """

  @doc """
  Returns Lokalise APIv2 token. Set it inside your `mix.exs`:
      config :elixir_lokalise_api, api_token: "YOUR_API_TOKEN"
  """
  def api_token, do: from_env(:api_token)

  @doc """
  Returns Lokalise APIv2 OAuth2 token. Set it inside your `mix.exs`:
      config :elixir_lokalise_api, oauth2_token: "YOUR_API_TOKEN"

  Or use Config.put_env/2 to set it on the fly:
      Config.put_env(:oauth2_token, "123abc")
  """
  def oauth2_token, do: from_env(:oauth2_token)

  def request_options, do: from_env(:request_options, Keyword.new())

  @doc """
  Returns package version
  """
  def version, do: from_env(:version, "2.1.0")

  @doc """
  Returns the base URL of the Lokalise APIv2
  """
  def base_url, do: "https://api.lokalise.com/api2/"

  @doc """
  A wrapper around `Application.put_env/3`
  """
  def put_env(key, value) do
    :elixir_lokalise_api
    |> Application.put_env(key, value)
  end

  @doc """
  A light wrapper around `Application.get_env/2`, providing automatic support for
  `{:system, "VAR"}` tuples. Based on https://github.com/danielberkompas/ex_twilio/blob/master/lib/ex_twilio/config.ex
  """
  def from_env(key, default \\ nil)

  def from_env(key, default) do
    :elixir_lokalise_api
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  # coveralls-ignore-start
  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  # coveralls-ignore-stop
  defp read_from_system(value, _default), do: value
end
