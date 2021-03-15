defmodule ElixirLokaliseApi.Model.TranslationProvider do
  defstruct provider_id: nil,
            name: nil,
            slug: nil,
            price_pair_min: nil,
            website_url: nil,
            description: nil,
            tiers: %{},
            pairs: %{}
end
