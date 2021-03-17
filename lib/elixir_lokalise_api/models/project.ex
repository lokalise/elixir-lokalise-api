defmodule ElixirLokaliseApi.Model.Project do
  @moduledoc false
  defstruct project_id: nil,
            project_type: nil,
            name: nil,
            description: nil,
            created_at: nil,
            created_at_timestamp: nil,
            created_by: nil,
            created_by_email: nil,
            team_id: nil,
            base_language_id: nil,
            base_language_iso: nil,
            settings: nil,
            statistics: nil
end
