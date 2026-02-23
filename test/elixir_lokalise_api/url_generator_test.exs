defmodule ElixirLokaliseApi.UrlGeneratorTest do
  use ExUnit.Case, async: true

  alias ElixirLokaliseApi.UrlGenerator

  defmodule ListFallbackEndpoint do
    def endpoint, do: "/list/{:qwe123}/tail"
  end

  defmodule MapStringKeyEndpoint do
    def endpoint, do: "/map_string/{!:project_id}/tail"
  end

  defmodule MapAtomKeyEndpoint do
    def endpoint, do: "/map_atom/{!:project_id}/tail"
  end

  defmodule MapRescueEndpoint do
    def endpoint, do: "/map_rescue/{:no_atom_key_xyz}/tail"
  end

  defmodule NonCollectionEndpoint do
    def endpoint, do: "/noncoll/{:project_id}/tail"
  end

  test "generates raises error when required param is missing" do
    assert_raise RuntimeError, ~r/^Required param project_id is missing/, fn ->
      UrlGenerator.generate(ElixirLokaliseApi.Contributors, %{
        url_params: Keyword.new(),
        for: :api
      })
    end
  end

  test "generates raises error when url_params is nil" do
    assert_raise RuntimeError, ~r/^Required param project_id is missing/, fn ->
      UrlGenerator.generate(ElixirLokaliseApi.Contributors, %{url_params: nil, for: :api})
    end
  end

  test "fetch_param for list params falls back to String.to_atom when atom does not exist" do
    url =
      UrlGenerator.generate(ListFallbackEndpoint, %{
        url_params: [some_other: 1],
        for: :api
      })

    assert String.ends_with?(url, "/list/tail")
  end

  test "fetch_param for map params finds value by string key" do
    url =
      UrlGenerator.generate(MapStringKeyEndpoint, %{
        url_params: %{"project_id" => 42},
        for: :api
      })

    assert String.ends_with?(url, "/map_string/42/tail")
  end

  test "fetch_param for map params falls back to atom key when string key is missing" do
    url =
      UrlGenerator.generate(MapAtomKeyEndpoint, %{
        url_params: %{project_id: 42},
        for: :api
      })

    assert String.ends_with?(url, "/map_atom/42/tail")
  end

  test "fetch_param for map params returns nil when neither string nor atom key exist" do
    url =
      UrlGenerator.generate(MapRescueEndpoint, %{
        url_params: %{},
        for: :api
      })

    assert String.ends_with?(url, "/map_rescue/tail")
  end

  test "fetch_param returns nil for non-list, non-map url_params" do
    url =
      UrlGenerator.generate(NonCollectionEndpoint, %{
        url_params: "wat",
        for: :api
      })

    assert String.ends_with?(url, "/noncoll/tail")
  end
end
