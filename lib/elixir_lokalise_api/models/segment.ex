defmodule ElixirLokaliseApi.Model.Segment do
  @moduledoc false
  defstruct segment_number: nil,
            language_iso: nil,
            modified_at: nil,
            modified_at_timestamp: nil,
            modified_by: nil,
            modified_by_email: nil,
            value: nil,
            is_fuzzy: nil,
            is_reviewed: nil,
            reviewed_by: nil,
            words: nil,
            custom_translation_statuses: []
end
