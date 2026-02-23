defmodule ElixirLokaliseApi.ConfigTest do
  use ExUnit.Case, async: true

  alias ElixirLokaliseApi.Config

  test "from_env returns a plain value" do
    assert Config.from_env(:request_options)
  end

  test "from_env returns a value under system" do
    assert Config.from_env(:api_token) != nil
  end

  test "oauth2_client_id returns an id" do
    assert Config.oauth2_client_id() != nil
  end

  test "oauth2_client_secret returns a secret" do
    assert Config.oauth2_client_secret() != nil
  end

  test "from_env returns a default value when missing" do
    assert Config.from_env(:missing, :ok) == :ok
  end

  test "from_env returns nil for non-existent keys" do
    assert Config.from_env(:nonexistent_config_key) == nil
  end

  test "put_env allows to set values dynamically" do
    old = Config.oauth2_token()

    try do
      token = "123abc"

      Config.put_env(:oauth2_token, token)
      assert Config.oauth2_token() == token

      Config.put_env(:oauth2_token, nil)
      assert Config.oauth2_token() == nil
    after
      Config.put_env(:oauth2_token, old)
    end
  end
end
