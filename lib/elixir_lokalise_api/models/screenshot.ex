defmodule ElixirLokaliseApi.Model.Screenshot do
  @moduledoc false
  defstruct screenshot_id: nil,
            key_ids: [],
            url: nil,
            title: nil,
            description: nil,
            screenshot_tags: [],
            width: nil,
            height: nil,
            created_at: nil,
            created_at_timestamp: nil
end
