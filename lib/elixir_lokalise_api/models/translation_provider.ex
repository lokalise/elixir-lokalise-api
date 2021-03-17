defmodule ElixirLokaliseApi.Model.TranslationProvider do
  @moduledoc false
  defstruct provider_id: nil,
            name: nil,
            slug: nil,
            price_pair_min: nil,
            website_url: nil,
            description: nil,
            tiers: %{},
            pairs: %{}
end
