defmodule ElixirLokaliseApi.OAuth2.Auth do
  @moduledoc """
  OAuth 2 authentication endpoint.
  """

  @endpoint "token"
  @model ElixirLokaliseApi.Model.OAuth2.Token
  @collection nil
  @data_key nil
  @parent_key nil
  @singular_data_key nil

  alias ElixirLokaliseApi.Config
  use ElixirLokaliseApi.DynamicResource

  @doc """
  Generates an authentication URL to obtain
  an authorization code.
  """
  def auth(scope, redirect_uri \\ nil, state \\ nil) do
    "#{Config.base_url(:oauth2)}auth"
    |> URI.new!()
    |> do_append(:client_id, Config.oauth2_client_id())
    |> do_append(:scope, Enum.join(scope, " "))
    |> do_append(:redirect_uri, redirect_uri)
    |> do_append(:state, state)
    |> URI.to_string()
  end

  @doc """
  Requests an OAuth2 token.
  """
  def token(code) do
    data = %{
      client_id: Config.oauth2_client_id(),
      client_secret: Config.oauth2_client_secret(),
      code: code,
      grant_type: "authorization_code"
    }

    make_request(:post,
      data: data,
      url_params: url_params(),
      for: :oauth2
    )
  end

  @doc """
  Refreshes an OAuth2 token.
  """
  def refresh(refresh_token) do
    data = %{
      client_id: Config.oauth2_client_id(),
      client_secret: Config.oauth2_client_secret(),
      refresh_token: refresh_token,
      grant_type: "refresh_token"
    }

    make_request(:post,
      data: data,
      url_params: url_params(),
      for: :oauth2
    )
  end

  defp do_append(uri, _param_name, nil), do: uri

  defp do_append(uri, param_name, param_val) do
    uri
    |> URI.append_query(URI.encode_query([{param_name, param_val}]))
  end
end
