defmodule ElixirLokaliseApiTest do
  use ExUnit.Case
  doctest ElixirLokaliseApi

  test "greets the world" do
    assert ElixirLokaliseApi.hello() == :world
  end
end
