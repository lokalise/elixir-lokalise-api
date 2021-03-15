defmodule ElixirLokaliseApi.KeysTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Keys
  alias ElixirLokaliseApi.Collection.Keys, as: KeysCollection
  alias ElixirLokaliseApi.Model.Key, as: KeyModel

  setup_all do
    HTTPoison.start()
  end

  doctest Keys

  @project_id "572560965f984614d567a4.18006942"

  test "lists all keys" do
    use_cassette "keys_all" do
      {:ok, %KeysCollection{} = keys} = Keys.all(@project_id)

      assert Enum.count(keys.items) == 5
      assert keys.total_count == 5
      assert keys.page_count == 1
      assert keys.per_page_limit == 100
      assert keys.current_page == 1
      assert keys.project_id == @project_id

      key = keys.items |> List.first()
      assert key.key_id == 79_039_606
    end
  end

  test "lists paginated keys" do
    use_cassette "keys_all_paginated" do
      {:ok, %KeysCollection{} = keys} = Keys.all(@project_id, page: 2, limit: 3)

      assert Enum.count(keys.items) == 2
      assert keys.total_count == 5
      assert keys.page_count == 2
      assert keys.per_page_limit == 3
      assert keys.current_page == 2
      assert keys.project_id == @project_id

      refute keys |> Pagination.first_page?()
      assert keys |> Pagination.last_page?()
      refute keys |> Pagination.next_page?()
      assert keys |> Pagination.prev_page?()

      key = keys.items |> List.first()
      assert key.key_id == 79_039_609
    end
  end

  test "finds a key" do
    use_cassette "keys_find" do
      key_id = 79_039_609
      {:ok, %KeyModel{} = key} = Keys.find(@project_id, key_id)

      assert key.key_id == key_id
      assert key.created_at == "2021-03-02 17:00:01 (Etc/UTC)"
      assert key.created_at_timestamp == 1_614_704_401
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
      assert key.modified_at_timestamp == 1_615_304_725
      assert key.translations_modified_at == "2021-03-09 15:45:34 (Etc/UTC)"
      assert key.translations_modified_at_timestamp == 1_615_304_734
    end
  end

  test "finds a key with params" do
    use_cassette "keys_find_params" do
      key_id = 79_039_609
      {:ok, %KeyModel{} = key} = Keys.find(@project_id, key_id, disable_references: "1")

      assert key.key_id == key_id
    end
  end

  test "creates a key" do
    use_cassette "keys_create" do
      data = %{
        keys: [
          %{
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
          }
        ]
      }

      {:ok, %KeysCollection{} = keys} = Keys.create(@project_id, data)

      key = keys.items |> List.first()
      assert key.key_name.android == "elixir"
      assert key.description == "Via API"
      assert List.first(key.translations).translation == "Hi from Elixir"
    end
  end

  test "creates a key with error" do
    use_cassette "keys_create_error" do
      data = %{
        keys: [
          %{
            key_name: %{
              web: "elixir",
              android: "elixir",
              ios: "elixir_ios",
              other: "el_other"
            },
            platforms: ["web", "android"],
            translations: [
              %{
                language_iso: "en",
                translation: "Hi from Elixir"
              }
            ]
          },
          %{
            key_name: %{
              web: "existing",
              android: "existing",
              ios: "existing",
              other: "existing"
            },
            platforms: ["web"],
            translations: [
              %{
                language_iso: "en",
                translation: "test"
              }
            ]
          }
        ]
      }

      {:ok, %KeysCollection{} = keys} = Keys.create(@project_id, data)

      key = keys.items |> List.first()
      assert key.key_name.android == "elixir"
      assert List.first(key.translations).translation == "Hi from Elixir"

      assert hd(keys.errors).message == "This key name is already taken"
    end
  end

  test "updates a key" do
    use_cassette "keys_update" do
      key_id = 80_125_772

      data = %{
        description: "Updated via SDK",
        tags: ["sample"]
      }

      {:ok, %KeyModel{} = key} = Keys.update(@project_id, key_id, data)

      assert key.key_id == key_id
      assert key.description == "Updated via SDK"
      assert key.tags == ["sample"]
    end
  end

  test "updates keys in bulk" do
    use_cassette "keys_update_bulk" do
      key_id = 80_125_772
      key_id2 = 79_039_609

      data = %{
        keys: [
          %{
            key_id: key_id,
            description: "Bulk updated via SDK",
            tags: ["sample"]
          },
          %{
            key_id: key_id2,
            platforms: ["web", "android"]
          }
        ]
      }

      {:ok, %KeysCollection{} = keys} = Keys.update_bulk(@project_id, data)

      assert Enum.count(keys.items) == 2
      [key1 | [key2 | []]] = keys.items
      assert Enum.sort(key1.platforms) == ["android", "web"]

      assert key2.description == "Bulk updated via SDK"
    end
  end

  test "deletes a key" do
    use_cassette "keys_delete" do
      key_id = 79_039_610

      {:ok, %{} = resp} = Keys.delete(@project_id, key_id)

      assert resp.key_removed
      assert resp.project_id == @project_id
    end
  end

  test "deletes keys in bulk" do
    use_cassette "keys_delete_bulk" do
      key_id = 80_125_772
      key_id2 = 79_039_609

      data = %{
        keys: [
          key_id,
          key_id2
        ]
      }

      {:ok, %{} = resp} = Keys.delete_bulk(@project_id, data)

      assert resp.keys_removed
      assert resp.project_id == @project_id
    end
  end
end
