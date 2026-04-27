defmodule ElixirLokaliseApi.TranslationProvidersTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.TranslationProviders, as: TranslationProvidersCollection
  alias ElixirLokaliseApi.Model.TranslationProvider, as: TranslationProviderModel
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TranslationProviders

  doctest TranslationProviders

  @team_id 176_692

  test "lists all translation providers" do
    response = %{
      translation_providers: [
        %{
          provider_id: 1,
          name: "Gengo",
          slug: "gengo",
          price_pair_min: "0.00",
          website_url: "https://gengo.com",
          description:
            "At Gengo, our mission is to provide language services to everyone and connect a global community. Our network of over 18,000 translators are tested and qualified to meet stringent project standards."
        },
        %{
          provider_id: 3,
          name: "Google",
          slug: "google",
          price_pair_min: "0.00",
          website_url: "https://translate.google.com",
          description:
            "Google Translate with neural machine translation support. NMT is not available for all language pairs yet."
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/translation_providers")

      response
      |> ok()
    end)

    {:ok, %TranslationProvidersCollection{} = translation_providers} =
      TranslationProviders.all(@team_id)

    assert Enum.count(translation_providers.items) == 2

    provider = hd(translation_providers.items)
    assert provider.provider_id == 1
  end

  test "lists paginated translation providers" do
    response = %{
      translation_providers: [
        %{
          provider_id: 1,
          name: "Gengo",
          slug: "gengo",
          price_pair_min: "0.00",
          website_url: "https://gengo.com",
          description:
            "At Gengo, our mission is to provide language services to everyone and connect a global community. Our network of over 18,000 translators are tested and qualified to meet stringent project standards."
        },
        %{
          provider_id: 3,
          name: "Google",
          slug: "google",
          price_pair_min: "0.00",
          website_url: "https://translate.google.com",
          description:
            "Google Translate with neural machine translation support. NMT is not available for all language pairs yet."
        }
      ]
    }

    params = [page: 2, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/translation_providers")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "4"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %TranslationProvidersCollection{} = translation_providers} =
      TranslationProviders.all(@team_id, params)

    assert Enum.count(translation_providers.items) == 2
    assert translation_providers.per_page_limit == 2
    assert translation_providers.current_page == 2

    refute translation_providers |> Pagination.first_page?()
    assert translation_providers |> Pagination.last_page?()

    provider = hd(translation_providers.items)
    assert provider.provider_id == 1
  end

  test "finds translation provider" do
    provider_id = 3

    response = %{
      provider_id: 3,
      name: "Google",
      slug: "google",
      price_pair_min: "0.00",
      website_url: "https://translate.google.com",
      description:
        "Google Translate with neural machine translation support. NMT is not available for all language pairs yet.",
      tiers: [
        %{
          tier_id: 1,
          title: "Machine translation"
        }
      ],
      pairs: [
        %{
          tier_id: 1,
          price_per_word: "0.001",
          from_lang_iso: "ru",
          from_lang_name: "Russian",
          to_lang_iso: "zh_TW",
          to_lang_name: "Chinese Traditional"
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/translation_providers/#{provider_id}")

      response
      |> ok()
    end)

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
