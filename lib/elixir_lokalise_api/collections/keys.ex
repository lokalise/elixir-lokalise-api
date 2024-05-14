defmodule ElixirLokaliseApi.Collection.Keys do
  @moduledoc false
  defstruct items: [],
            project_id: nil,
            total_count: nil,
            page_count: nil,
            per_page_limit: nil,
            current_page: nil,
            next_cursor: nil,
            errors: []
end
