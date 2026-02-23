defmodule ElixirLokaliseApi.SystemLanguagesTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.SystemLanguages
  alias ElixirLokaliseApi.Collection.Languages, as: LanguagesCollection

  doctest SystemLanguages

  test "lists all system languages" do
    response = %{
      languages: [
        %{
          lang_id: 792,
          lang_iso: "af_ZA",
          lang_name: "Afrikaans (South Africa)",
          is_rtl: false,
          plural_forms: ["one", "other"]
        },
        %{
          lang_id: 977,
          lang_iso: "agq",
          lang_name: "Aghem",
          is_rtl: false,
          plural_forms: ["zero", "one", "two", "few", "many", "other"]
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/system/languages")

      response
      |> ok()
    end)

    {:ok, %LanguagesCollection{} = languages} = SystemLanguages.all()
    language = hd(languages.items)

    assert language.lang_iso == "af_ZA"
    assert Enum.count(languages.items) == 2
  end

  test "lists paginated system languages" do
    response = %{
      languages: [
        %{
          lang_id: 792,
          lang_iso: "af_ZA",
          lang_name: "Afrikaans (South Africa)",
          is_rtl: false,
          plural_forms: ["one", "other"]
        },
        %{
          lang_id: 977,
          lang_iso: "agq",
          lang_name: "Aghem",
          is_rtl: false,
          plural_forms: ["zero", "one", "two", "few", "many", "other"]
        }
      ]
    }

    params = [page: 3, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/system/languages")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "600"},
        {"x-pagination-page-count", "300"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "3"}
      ])
    end)

    {:ok, %LanguagesCollection{} = languages} = SystemLanguages.all(params)
    language = hd(languages.items)

    assert language.lang_iso == "af_ZA"
    assert Enum.count(languages.items) == 2
    assert languages.total_count == 600
    assert languages.page_count == 300
    assert languages.per_page_limit == 2
    assert languages.current_page == 3

    refute languages |> Pagination.first_page?()
    refute languages |> Pagination.last_page?()
    assert languages |> Pagination.next_page?()
    assert languages |> Pagination.prev_page?()
  end
end
