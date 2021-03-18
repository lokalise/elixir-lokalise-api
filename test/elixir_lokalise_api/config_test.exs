defmodule ElixirLokaliseApi.ConfigTest do
  use ExUnit.Case, async: true

  alias ElixirLokaliseApi.Config

  test "from_env returns a plain value" do
    app = Config.app_config()[:app]
    assert Config.from_env(app, :request_options)
  end

  test "from_env returns a value under system" do
    app = Config.app_config()[:app]
    assert Config.from_env(app, :api_token) != nil
  end

  test "from_env returns a default value when missing" do
    app = Config.app_config()[:app]
    assert Config.from_env(app, :missing, :ok) == :ok
  end
end
