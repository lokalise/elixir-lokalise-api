defmodule ElixirLokaliseApi.TranslationsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Translations
  alias ElixirLokaliseApi.Collection.Translations, as: TranslationsCollection
  alias ElixirLokaliseApi.Model.Translation, as: TranslationModel

  setup_all do
    HTTPoison.start()
  end

  doctest Translations

  @project_id "287061316050d93a27ada8.24068671"
  @project_id2 "2273827860c1e2473eb195.11207948"

  test "lists all translations" do
    use_cassette "translations_all" do
      {:ok, %TranslationsCollection{} = translations} = Translations.all(@project_id)

      assert Enum.count(translations.items) == 6

      translation = hd(translations.items)
      assert translation.translation_id == 580_728_816
    end
  end

  test "lists paginated translations" do
    use_cassette "translations_all_paginated" do
      {:ok, %TranslationsCollection{} = translations} =
        Translations.all(@project_id, filter_is_reviewed: 0, page: 2, limit: 1)

      assert Enum.count(translations.items) == 1
      assert translations.total_count == 6
      assert translations.page_count == 6
      assert translations.per_page_limit == 1
      assert translations.current_page == 2

      refute translations |> Pagination.first_page?()
      refute translations |> Pagination.last_page?()
      assert translations |> Pagination.next_page?()
      assert translations |> Pagination.prev_page?()

      translation = hd(translations.items)
      assert translation.translation_id == 580_728_817
    end
  end

  test "lists paginated with cursor translations" do
    use_cassette "translations_all_paginated_cursor" do
      {:ok, %TranslationsCollection{} = translations} =
        Translations.all(@project_id2,
          limit: 2,
          pagination: "cursor",
          cursor: "eyIxIjozMDU0Mzg5ODQ0fQ=="
        )

      assert Enum.count(translations.items) == 2
      assert translations.per_page_limit == 2
      assert translations.next_cursor == "eyIxIjozMDU0Mzg5ODQ2fQ=="
    end
  end

  test "finds a translation" do
    use_cassette "translation_find" do
      translation_id = 580_728_816
      {:ok, %TranslationModel{} = translation} = Translations.find(@project_id, translation_id)

      assert translation.translation_id == translation_id
      assert translation.key_id == 81_096_689
      assert translation.language_iso == "ru"
      assert translation.modified_at == "2021-03-16 16:25:40 (Etc/UTC)"
      assert translation.modified_at_timestamp == 1_615_911_940
      assert translation.modified_by == 20181
      assert translation.modified_by_email == "bodrovis@protonmail.com"
      assert String.ends_with?(translation.translation, "e-mail")
      refute translation.is_unverified
      refute translation.is_reviewed
      assert translation.reviewed_by == 0
      assert translation.words == 2
      assert translation.custom_translation_statuses == []
      refute translation.task_id
    end
  end

  test "finds a translation with params" do
    use_cassette "translation_find_params" do
      translation_id = 580_728_816

      {:ok, %TranslationModel{} = translation} =
        Translations.find(@project_id, translation_id, disable_references: 1)

      assert translation.translation_id == translation_id
      assert translation.key_id == 81_096_689
    end
  end

  test "updates a translation" do
    use_cassette "translation_update" do
      translation_id = 580_728_816

      data = %{
        translation: "Updated!",
        is_reviewed: true
      }

      {:ok, %TranslationModel{} = translation} =
        Translations.update(@project_id, translation_id, data)

      assert translation.translation_id == translation_id
      assert translation.translation == "Updated!"
      assert translation.is_reviewed
    end
  end
end
