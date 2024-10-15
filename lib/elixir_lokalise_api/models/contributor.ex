defmodule ElixirLokaliseApi.Model.Contributor do
  @moduledoc false
  defstruct user_id: nil,
            email: nil,
            fullname: nil,
            created_at: nil,
            created_at_timestamp: nil,
            is_admin: nil,
            is_reviewer: nil,
            languages: %{},
            admin_rights: [],
            role_id: nil
end
