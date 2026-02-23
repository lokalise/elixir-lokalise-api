defmodule ElixirLokaliseApi.HTTPClient.FinchImpl do
  @moduledoc """
  A minimal HTTP client implementation that simply delegates requests to `Finch.request/3`.

  This module acts as the default runtime HTTP adapter for the library.
  In tests it is typically replaced with a mock via the `ElixirLokaliseApi.HTTPClient`
  behaviour, which is why this implementation is intentionally thin and not directly tested.
  """

  @behaviour ElixirLokaliseApi.HTTPClient

  @impl ElixirLokaliseApi.HTTPClient
  def request(req, name, opts) do
    # coveralls-ignore-start
    Finch.request(req, name, opts)
    # coveralls-ignore-stop
  end
end
