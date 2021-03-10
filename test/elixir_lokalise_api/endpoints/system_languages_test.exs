defmodule ElixirLokaliseApi.SystemLanguagesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.SystemLanguages
  alias ElixirLokaliseApi.Collection.Languages, as: LanguagesCollection

  setup_all do
    HTTPoison.start
  end

  doctest SystemLanguages

  test "lists all system languages" do
    use_cassette "system_languages_all" do
      {:ok, %LanguagesCollection{} = languages} = SystemLanguages.all
      language = hd languages.items

      assert language.lang_iso == "ab"
      assert Enum.count(languages.items) == 100
    end
  end

  test "lists paginated system languages" do
    use_cassette "system_languages_all_paginated" do
      {:ok, %LanguagesCollection{} = languages} = SystemLanguages.all page: 3, limit: 2
      language = hd languages.items

      assert language.lang_iso == "af_ZA"
      assert Enum.count(languages.items) == 2
      assert languages.total_count == 666
      assert languages.page_count == 333
      assert languages.per_page_limit == 2
      assert languages.current_page == 3

      refute languages |> Pagination.first_page?
      refute languages |> Pagination.last_page?
      assert languages |> Pagination.next_page?
      assert languages |> Pagination.prev_page?
    end
  end
end
