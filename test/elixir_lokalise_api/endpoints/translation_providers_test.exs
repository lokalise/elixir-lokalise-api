defmodule ElixirLokaliseApi.TranslationProvidersTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TranslationProviders
  alias ElixirLokaliseApi.Model.TranslationProvider, as: TranslationProviderModel
  alias ElixirLokaliseApi.Collection.TranslationProviders, as: TranslationProvidersCollection

  setup_all do
    HTTPoison.start()
  end

  doctest TranslationProviders

  @team_id 176_692

  test "lists all translation providers" do
    use_cassette "translation_providers_all" do
      {:ok, %TranslationProvidersCollection{} = translation_providers} =
        TranslationProviders.all(@team_id)

      assert Enum.count(translation_providers.items) == 4

      provider = hd(translation_providers.items)
      assert provider.provider_id == 1
    end
  end

  test "lists paginated translation providers" do
    use_cassette "translation_providers_all_paginated" do
      {:ok, %TranslationProvidersCollection{} = translation_providers} =
        TranslationProviders.all(@team_id, page: 2, limit: 1)

      assert Enum.count(translation_providers.items) == 1
      assert translation_providers.per_page_limit == 1
      assert translation_providers.current_page == 2

      refute translation_providers |> Pagination.first_page?()
      assert translation_providers |> Pagination.last_page?()

      provider = hd(translation_providers.items)
      assert provider.provider_id == 3
    end
  end

  test "finds translation provider" do
    use_cassette "translation_provider_find" do
      provider_id = 3

      {:ok, %TranslationProviderModel{} = provider} =
        TranslationProviders.find(@team_id, provider_id)

      assert provider.provider_id == provider_id
      assert provider.name == "Google"
      assert provider.slug == "google"
      assert provider.price_pair_min == "0.00"
      assert provider.website_url == "https://translate.google.com"

      assert provider.description ==
               "Google Translate with neural machine translation support. NMT is not available for all language pairs yet."

      assert hd(provider.tiers).tier_id == 1
      assert hd(provider.pairs).price_per_word == "0.001"
    end
  end
end
