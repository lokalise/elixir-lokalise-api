defmodule ElixirLokaliseApi.HTTPClient.FinchImpl do
  @behaviour ElixirLokaliseApi.HTTPClient

  def request(req, name, opts) do
    Finch.request(req, name, opts)
  end
end
