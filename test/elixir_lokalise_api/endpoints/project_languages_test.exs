defmodule ElixirLokaliseApi.ProjectLanguagesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.ProjectLanguages
  alias ElixirLokaliseApi.Model.Language, as: LanguageModel
  alias ElixirLokaliseApi.Collection.Languages, as: LanguagesCollection

  setup_all do
    HTTPoison.start
  end

  doctest ProjectLanguages

  @project_id "572560965f984614d567a4.18006942"

  test "lists all project languages" do
    use_cassette "project_languages_all" do
      {:ok, %LanguagesCollection{} = languages} = ProjectLanguages.all "217830385f9c0fdbd589f0.91420183"

      assert Enum.count(languages.items) == 2
      language = languages.items |> hd
      assert language.lang_iso == "en"
    end
  end

  test "lists paginated project languages" do
    use_cassette "project_languages_all_paginated" do
      {:ok, %LanguagesCollection{} = languages} = ProjectLanguages.all @project_id, page: 3, limit: 2

      assert Enum.count(languages.items) == 1
      assert languages.project_id == @project_id
      assert languages.total_count == 5
      assert languages.page_count == 3
      assert languages.per_page_limit == 2
      assert languages.current_page == 3

      refute languages |> Pagination.first_page?
      assert languages |> Pagination.last_page?
      refute languages |> Pagination.next_page?
      assert languages |> Pagination.prev_page?

      language = languages.items |> hd
      assert language.lang_iso == "lv_LV"
    end
  end

  test "finds a project language" do
    use_cassette "project_language_find" do
      lang_id = 800
      {:ok, %LanguageModel{} = language} = ProjectLanguages.find @project_id, lang_id

      assert language.lang_id == lang_id
      assert language.lang_iso == "lv_LV"
      assert language.lang_name == "Latvian (Latvia)"
      refute language.is_rtl
      assert language.plural_forms == ["zero", "one", "other"]
    end
  end

  test "creates project languages" do
    use_cassette "project_languages_create" do
      data = %{languages: [
        %{
          lang_iso: "ab",
          custom_iso: "samp"
        },
        %{
          lang_iso: "ru",
          custom_name: "Sample"
        }
      ]}

      {:ok, %LanguagesCollection{} = languages} = ProjectLanguages.create @project_id, data

      assert Enum.count(languages.items) == 2
      [ lang1 | [ lang2 | [] ] ] = languages.items

      assert lang1.lang_iso == "samp"
      assert lang2.lang_name == "Sample"
    end
  end

  test "creates project languages with errors" do
    use_cassette "project_languages_create_errors" do
      data = %{languages: [
        %{
          lang_iso: "ru"
        },
        %{
          lang_iso: "nl"
        }
      ]}

      {:ok, %LanguagesCollection{} = languages} = ProjectLanguages.create @project_id, data

      lang = hd languages.items
      assert lang.lang_iso == "nl"

      assert hd(languages.errors).message == "Language is already added to the project"
    end
  end

  test "updates a project language" do
    use_cassette "project_language_update" do
      lang_id = 894
      data = %{
        lang_name: "Updated"
      }

      {:ok, %LanguageModel{} = language} = ProjectLanguages.update @project_id, lang_id, data

      assert language.lang_name == "Updated"
    end
  end

  test "deletes a project language" do
    use_cassette "project_language_delete" do
      lang_id = 597

      {:ok, %{} = resp} = ProjectLanguages.delete @project_id, lang_id
      assert resp.language_deleted
      assert resp.project_id == @project_id
    end
  end
end
