defmodule ElixirLokaliseApi.ConfigTest do
  use ExUnit.Case, async: true

  alias ElixirLokaliseApi.Config

  test "from_env returns a plain value" do
    assert Config.from_env(:request_options)
  end

  test "from_env returns a value under system" do
    assert Config.from_env(:api_token) != nil
  end

  test "from_env returns a default value when missing" do
    assert Config.from_env(:missing, :ok) == :ok
  end

  test "from_env returns nil for non-existent keys" do
    refute Config.oauth2_token()
  end

  test "put_env allows to set values dynamically" do
    token = "123abc"
    :oauth2_token |> Config.put_env(token)
    assert Config.oauth2_token() == token

    :oauth2_token |> Config.put_env(nil)
    refute Config.oauth2_token()
  end
end
