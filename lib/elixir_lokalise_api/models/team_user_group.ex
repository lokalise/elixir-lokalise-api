defmodule ElixirLokaliseApi.Model.TeamUserGroup do
  @moduledoc false
  defstruct group_id: nil,
            name: nil,
            permissions: %{},
            created_at: nil,
            created_at_timestamp: nil,
            team_id: nil,
            projects: [],
            members: [],
            role_id: nil
end
