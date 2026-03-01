defmodule ElixirLokaliseApi.RequestTokenTest do
  use ElixirLokaliseApi.Case, async: false

  alias ElixirLokaliseApi.Request

  defmodule DummyEndpoint do
    def endpoint, do: "/dummy"
  end

  test "do_request raises when neither oauth2_token nor api_token is configured" do
    old_api_token = Application.get_env(:elixir_lokalise_api, :api_token)
    old_oauth2_token = Application.get_env(:elixir_lokalise_api, :oauth2_token)

    on_exit(fn ->
      Application.put_env(:elixir_lokalise_api, :api_token, old_api_token)
      Application.put_env(:elixir_lokalise_api, :oauth2_token, old_oauth2_token)
    end)

    Application.delete_env(:elixir_lokalise_api, :api_token)
    Application.delete_env(:elixir_lokalise_api, :oauth2_token)

    assert_raise ArgumentError, ~r/Missing Lokalise API token/, fn ->
      Request.do_request(:get, DummyEndpoint, [])
    end
  end
end
