defmodule ElixirLokaliseApi.ProjectLanguagesTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.Languages, as: LanguagesCollection
  alias ElixirLokaliseApi.Model.Language, as: LanguageModel
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.ProjectLanguages

  doctest ProjectLanguages

  @project_id "572560965f984614d567a4.18006942"

  test "lists all project languages" do
    response = %{
      project_id: @project_id,
      languages: [
        %{
          lang_id: 640,
          lang_iso: "en",
          lang_name: "English",
          is_rtl: false,
          plural_forms: ["one", "other"]
        },
        %{
          lang_id: 600,
          lang_iso: "ru_RU",
          lang_name: "Russian (Russia)",
          is_rtl: false,
          plural_forms: ["one", "few", "many", "other"]
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/languages")

      response
      |> ok()
    end)

    {:ok, %LanguagesCollection{} = languages} =
      ProjectLanguages.all(@project_id)

    assert Enum.count(languages.items) == 2
    language = languages.items |> hd()
    assert language.lang_iso == "en"
  end

  test "lists paginated project languages" do
    response = %{
      project_id: @project_id,
      languages: [
        %{
          lang_id: 640,
          lang_iso: "en",
          lang_name: "English",
          is_rtl: false,
          plural_forms: ["one", "other"]
        },
        %{
          lang_id: 600,
          lang_iso: "ru_RU",
          lang_name: "Russian (Russia)",
          is_rtl: false,
          plural_forms: ["one", "few", "many", "other"]
        }
      ]
    }

    params = [page: 3, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/languages")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "5"},
        {"x-pagination-page-count", "3"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "3"}
      ])
    end)

    {:ok, %LanguagesCollection{} = languages} =
      ProjectLanguages.all(@project_id, params)

    assert Enum.count(languages.items) == 2
    assert languages.project_id == @project_id
    assert languages.total_count == 5
    assert languages.page_count == 3
    assert languages.per_page_limit == 2
    assert languages.current_page == 3

    refute languages |> Pagination.first_page?()
    assert languages |> Pagination.last_page?()
    refute languages |> Pagination.next_page?()
    assert languages |> Pagination.prev_page?()

    language = languages.items |> hd()
    assert language.lang_iso == "en"
  end

  test "finds a project language" do
    lang_id = 800

    response = %{
      project_id: @project_id,
      language: %{
        lang_id: lang_id,
        lang_iso: "lv_LV",
        lang_name: "Latvian (Latvia)",
        is_rtl: false,
        plural_forms: ["zero", "one", "other"]
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/languages/#{lang_id}")

      response
      |> ok()
    end)

    {:ok, %LanguageModel{} = language} = ProjectLanguages.find(@project_id, lang_id)

    assert language.lang_id == lang_id
    assert language.lang_iso == "lv_LV"
    assert language.lang_name == "Latvian (Latvia)"
    refute language.is_rtl
    assert language.plural_forms == ["zero", "one", "other"]
  end

  test "creates project languages" do
    data = %{
      languages: [
        %{
          lang_iso: "fr",
          custom_iso: "sample"
        },
        %{
          lang_iso: "nl",
          custom_name: "Dutch"
        }
      ]
    }

    response = %{
      project_id: @project_id,
      languages: [
        %{
          lang_id: "737",
          lang_iso: "nl",
          lang_name: "Dutch",
          is_rtl: false,
          plural_forms: ["one", "other"]
        }
      ],
      errors: [
        %{
          message: "Language is already added to the project",
          code: 208,
          lang_iso: "fr"
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/languages", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %LanguagesCollection{} = languages} = ProjectLanguages.create(@project_id, data)

    assert Enum.count(languages.items) == 1
    lang = languages.items |> hd()

    assert lang.lang_iso == "nl"
    assert lang.lang_name == "Dutch"

    assert hd(languages.errors).message == "Language is already added to the project"
  end

  test "updates a project language" do
    lang_id = 894

    response = %{
      project_id: @project_id,
      language: %{
        lang_id: lang_id,
        lang_iso: "samp",
        lang_name: "Updated",
        is_rtl: false,
        plural_forms: ["zero", "one", "two", "few", "many", "other"]
      }
    }

    data = %{
      lang_name: "Updated"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/languages/#{lang_id}", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %LanguageModel{} = language} = ProjectLanguages.update(@project_id, lang_id, data)

    assert language.lang_name == "Updated"
  end

  test "deletes a project language" do
    lang_id = 597

    response = %{
      project_id: @project_id,
      language_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/languages/#{lang_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = ProjectLanguages.delete(@project_id, lang_id)
    assert resp.language_deleted
    assert resp.project_id == @project_id
  end
end
