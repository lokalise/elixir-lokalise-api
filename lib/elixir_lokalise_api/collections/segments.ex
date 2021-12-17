defmodule ElixirLokaliseApi.Collection.Segments do
  @moduledoc false
  defstruct items: [],
            project_id: nil,
            total_count: nil,
            page_count: nil,
            per_page_limit: nil,
            current_page: nil,
            branch: nil,
            language_iso: nil,
            key_id: nil
end
