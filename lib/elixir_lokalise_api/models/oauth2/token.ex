defmodule ElixirLokaliseApi.Model.OAuth2.Token do
  @moduledoc false
  defstruct access_token: nil,
            refresh_token: nil,
            expires_in: nil,
            token_type: nil,
            scope: nil
end
