defmodule ElixirLokaliseApi.KeysTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Keys
  alias ElixirLokaliseApi.Collection.Keys, as: KeysCollection
  alias ElixirLokaliseApi.Model.Key, as: KeyModel

  setup_all do
    HTTPoison.start
  end

  doctest Keys

  @project_id "572560965f984614d567a4.18006942"

  test "lists all keys" do
    use_cassette "keys_all" do
      {:ok, %KeysCollection{} = keys} = Keys.all @project_id

      assert Enum.count(keys.items) == 5
      assert keys.total_count == 5
      assert keys.page_count == 1
      assert keys.per_page_limit == 100
      assert keys.current_page == 1
      assert keys.project_id == @project_id

      key = keys.items |> List.first()
      assert key.key_id == 79039606
    end
  end

  test "lists paginated keys" do
    use_cassette "keys_all_paginated" do
      {:ok, %KeysCollection{} = keys} = Keys.all @project_id, page: 2, limit: 3

      assert Enum.count(keys.items) == 2
      assert keys.total_count == 5
      assert keys.page_count == 2
      assert keys.per_page_limit == 3
      assert keys.current_page == 2
      assert keys.project_id == @project_id

      refute keys |> Pagination.first_page?
      assert keys |> Pagination.last_page?
      refute keys |> Pagination.next_page?
      assert keys |> Pagination.prev_page?

      key = keys.items |> List.first()
      assert key.key_id == 79039609
    end
  end

  test "finds a key" do
    use_cassette "keys_find" do
      key_id = 79039609
      {:ok, %KeyModel{} = key} = Keys.find @project_id, key_id

      assert key.key_id == key_id
      assert key.created_at == "2021-03-02 17:00:01 (Etc/UTC)"
      assert key.created_at_timestamp == 1614704401
      assert key.key_name.android == "headline"
      assert key.filenames.web == ""
      assert key.description == ""
      assert key.platforms == ["web"]
      assert List.first(key.tags) == "Home"
      assert key.comments == []
      assert key.screenshots == []
      assert List.first(key.translations).translation == "Join our community!"
      refute key.is_plural
      assert key.plural_name == ""
      refute key.is_hidden
      refute key.is_archived
      assert key.context == ""
      assert key.base_words == 3
      assert key.char_limit == 0
      assert key.custom_attributes == ""
      assert key.modified_at == "2021-03-09 15:45:25 (Etc/UTC)"
      assert key.modified_at_timestamp == 1615304725
      assert key.translations_modified_at == "2021-03-09 15:45:34 (Etc/UTC)"
      assert key.translations_modified_at_timestamp == 1615304734
    end
  end

  test "finds a key with params" do
    use_cassette "keys_find_params" do
      key_id = 79039609
      {:ok, %KeyModel{} = key} = Keys.find @project_id, key_id, disable_references: "1"

      assert key.key_id == key_id
    end
  end

  test "creates a key" do
    use_cassette "keys_create" do
      data = %{
        keys: [%{
          key_name: %{
            web: "elixir",
            android: "elixir",
            ios: "elixir_ios",
            other: "el_other"
          },
          description: "Via API",
          platforms: ["web", "android"],
          translations: [
            %{
                language_iso: "en",
                translation: "Hi from Elixir"
            },
            %{
              language_iso: "fr",
              translation: "test"
            }
          ]
        }]
      }
      {:ok, %KeysCollection{} = keys} = Keys.create @project_id, data

      key = keys.items |> List.first
      assert key.key_name.android == "elixir"
      assert key.description == "Via API"
      assert List.first(key.translations).translation == "Hi from Elixir"
    end
  end
end
