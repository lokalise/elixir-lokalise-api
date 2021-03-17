defmodule ElixirLokaliseApi.Collection.TeamUserGroups do
  @moduledoc false
  defstruct items: [],
            team_id: nil,
            total_count: nil,
            page_count: nil,
            per_page_limit: nil,
            current_page: nil
end
