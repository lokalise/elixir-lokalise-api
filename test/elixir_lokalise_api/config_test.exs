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
end
