defmodule ElixirLokaliseApi.Model.Team do
  @moduledoc false
  defstruct team_id: nil,
            name: nil,
            created_at: nil,
            created_at_timestamp: nil,
            plan: nil,
            quota_usage: %{},
            quota_allowed: %{}
end
