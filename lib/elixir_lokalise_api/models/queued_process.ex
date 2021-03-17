defmodule ElixirLokaliseApi.Model.QueuedProcess do
  @moduledoc false
  defstruct process_id: nil,
            type: nil,
            status: nil,
            message: nil,
            created_by: nil,
            created_by_email: nil,
            created_at: nil,
            created_at_timestamp: nil
end
