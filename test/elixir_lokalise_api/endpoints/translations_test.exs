defmodule ElixirLokaliseApi.TranslationsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Translations
  alias ElixirLokaliseApi.Collection.Translations, as: TranslationsCollection
  alias ElixirLokaliseApi.Model.Translation, as: TranslationModel

  doctest Translations

  @project_id "287061316050d93a27ada8.24068671"
  @translation_id 580_728_816

  test "lists all translations" do
    response = %{
      project_id: @project_id,
      translations: [
        %{
          translation_id: @translation_id,
          key_id: 81_096_689
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/translations")

      response
      |> ok()
    end)

    {:ok, %TranslationsCollection{} = translations} = Translations.all(@project_id)

    assert Enum.count(translations.items) == 1

    translation = hd(translations.items)
    assert translation.translation_id == @translation_id
  end

  test "lists paginated translations" do
    response = %{
      project_id: @project_id,
      translations: [
        %{
          translation_id: @translation_id,
          key_id: 81_096_689
        }
      ]
    }

    params = [filter_is_reviewed: 0, page: 2, limit: 1]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/translations")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "3"},
        {"x-pagination-page-count", "3"},
        {"x-pagination-limit", "1"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %TranslationsCollection{} = translations} =
      Translations.all(@project_id, params)

    assert Enum.count(translations.items) == 1
    assert translations.total_count == 3
    assert translations.page_count == 3
    assert translations.per_page_limit == 1
    assert translations.current_page == 2

    refute translations |> Pagination.first_page?()
    refute translations |> Pagination.last_page?()
    assert translations |> Pagination.next_page?()
    assert translations |> Pagination.prev_page?()

    translation = hd(translations.items)
    assert translation.translation_id == @translation_id
  end

  test "lists paginated with cursor translations" do
    response = %{
      project_id: @project_id,
      translations: [
        %{
          translation_id: @translation_id,
          key_id: 81_096_689
        }
      ]
    }

    params = [limit: 2, pagination: "cursor", cursor: "eyIxIjozMDU0Mzg5ODQ0fQ=="]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/translations")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-next-cursor", "200"},
        {"x-pagination-limit", "1"}
      ])
    end)

    {:ok, %TranslationsCollection{} = translations} =
      Translations.all(
        @project_id,
        params
      )

    assert Enum.count(translations.items) == 1
    assert translations.per_page_limit == 1
    assert translations.next_cursor == 200
  end

  test "finds a translation" do
    response = %{
      project_id: @project_id,
      translation: %{
        translation_id: @translation_id,
        key_id: 81_096_689,
        language_iso: "en",
        translation: "your e-mail",
        modified_by: 20_181,
        modified_by_email: "user@example.com",
        modified_at: "2021-03-16 16:25:40 (Etc/UTC)",
        modified_at_timestamp: 1_615_911_940,
        is_reviewed: false,
        reviewed_by: 0,
        is_unverified: false,
        is_fuzzy: false,
        words: 2,
        custom_translation_statuses: [],
        task_id: nil
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/translations/#{@translation_id}")

      response
      |> ok()
    end)

    {:ok, %TranslationModel{} = translation} = Translations.find(@project_id, @translation_id)

    assert translation.translation_id == @translation_id
    assert translation.key_id == 81_096_689
    assert translation.language_iso == "en"
    assert translation.modified_at == "2021-03-16 16:25:40 (Etc/UTC)"
    assert translation.modified_at_timestamp == 1_615_911_940
    assert translation.modified_by == 20_181
    assert translation.modified_by_email == "user@example.com"
    assert String.ends_with?(translation.translation, "e-mail")
    refute translation.is_unverified
    refute translation.is_reviewed
    assert translation.reviewed_by == 0
    assert translation.words == 2
    assert translation.custom_translation_statuses == []
    refute translation.task_id
  end

  test "finds a translation with params" do
    response = %{
      project_id: @project_id,
      translation: %{
        translation_id: @translation_id,
        key_id: 81_096_689
      }
    }

    params = [disable_references: 1]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/translations/#{@translation_id}")

      req
      |> assert_get_params(params)

      response
      |> ok()
    end)

    {:ok, %TranslationModel{} = translation} =
      Translations.find(@project_id, @translation_id, params)

    assert translation.translation_id == @translation_id
    assert translation.key_id == 81_096_689
  end

  test "updates a translation" do
    data = %{
      translation: "Updated!",
      is_reviewed: true
    }

    response = %{
      project_id: @project_id,
      translation: %{
        translation_id: @translation_id,
        key_id: 81_096_689,
        language_iso: "en",
        translation: "Updated!"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/translations/#{@translation_id}",
        "PUT"
      )

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TranslationModel{} = translation} =
      Translations.update(@project_id, @translation_id, data)

    assert translation.translation_id == @translation_id
    assert translation.translation == "Updated!"
  end
end
