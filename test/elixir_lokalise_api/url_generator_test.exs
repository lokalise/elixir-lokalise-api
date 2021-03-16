defmodule ElixirLokaliseApi.UrlGeneratorTest do
  use ExUnit.Case, async: true

  alias ElixirLokaliseApi.UrlGenerator

  test "generates raises error when required param is missing" do
    assert_raise RuntimeError, ~r/^Reqired param project_id is missing/, fn ->
      UrlGenerator.generate(ElixirLokaliseApi.Contributors, %{url_params: Keyword.new()})
    end
  end

  test "generates raises error when url_params is nil" do
    assert_raise RuntimeError, ~r/^Reqired param project_id is missing/, fn ->
      UrlGenerator.generate(ElixirLokaliseApi.Contributors, %{url_params: nil})
    end
  end
end
