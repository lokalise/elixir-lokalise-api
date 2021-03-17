defmodule ElixirLokaliseApi.Model.Order do
  @moduledoc false
  defstruct order_id: nil,
            project_id: nil,
            branch: nil,
            payment_method: nil,
            card_id: nil,
            status: nil,
            created_at: nil,
            created_at_timestamp: nil,
            created_by: nil,
            created_by_email: nil,
            source_language_iso: nil,
            target_language_isos: [],
            keys: [],
            source_words: %{},
            provider_slug: nil,
            translation_style: nil,
            translation_tier: nil,
            translation_tier_name: nil,
            briefing: nil,
            total: nil,
            dry_run: nil
end
