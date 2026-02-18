defmodule ElixirLokaliseApi.HTTPClient do
  @callback request(
              Finch.Request.t(),
              atom(),
              keyword()
            ) :: {:ok, Finch.Response.t()} | {:error, term()}
end
