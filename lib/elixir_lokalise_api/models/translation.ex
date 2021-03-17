defmodule ElixirLokaliseApi.Model.Translation do
  defstruct translation_id: nil,
            key_id: nil,
            language_iso: nil,
            modified_at: nil,
            modified_at_timestamp: nil,
            modified_by: nil,
            modified_by_email: nil,
            translation: nil,
            is_unverified: nil,
            is_reviewed: nil,
            reviewed_by: nil,
            words: nil,
            custom_translation_statuses: nil,
            task_id: nil
end
