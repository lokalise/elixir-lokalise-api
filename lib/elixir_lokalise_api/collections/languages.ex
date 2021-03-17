defmodule ElixirLokaliseApi.Collection.Languages do
  @moduledoc false
  defstruct items: [],
            total_count: nil,
            page_count: nil,
            per_page_limit: nil,
            current_page: nil,
            project_id: nil,
            errors: []
end
