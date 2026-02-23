defmodule ElixirLokaliseApi.HTTPClient do
  @moduledoc """
  Behaviour definition for HTTP client adapters used by the Lokalise API client.

  This behaviour allows the library to remain transport-agnostic by abstracting
  over the actual HTTP implementation. The default implementation, based on Finch,
  is provided by `ElixirLokaliseApi.HTTPClient.FinchImpl`, while tests typically
  replace it with a mock via `Mox`.

  Any custom adapter must implement the `request/3` callback and return either a
  successful `{:ok, Finch.Response.t()}` tuple or an `{:error, term()}` tuple.
  """

  @callback request(
              Finch.Request.t(),
              atom(),
              keyword()
            ) :: {:ok, Finch.Response.t()} | {:error, term()}
end
