defmodule ElixirLokaliseApi.KeysTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Keys
  alias ElixirLokaliseApi.Collection.Keys, as: KeysCollection
  alias ElixirLokaliseApi.Model.Key, as: KeyModel

  doctest Keys

  @project_id "572560965f984614d567a4.18006942"

  test "lists all keys" do
    keys =
      for i <- 1..3 do
        %{
          key_id: 20_000 + i,
          description: "Key #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      keys: keys
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys")

      response
      |> ok([
        {"x-pagination-total-count", "3"},
        {"x-pagination-page-count", "1"},
        {"x-pagination-limit", "100"},
        {"x-pagination-page", "1"}
      ])
    end)

    {:ok, %KeysCollection{} = keys} = Keys.all(@project_id)

    assert Enum.count(keys.items) == 3
    assert keys.total_count == 3
    assert keys.page_count == 1
    assert keys.per_page_limit == 100
    assert keys.current_page == 1
    assert keys.project_id == @project_id

    key = keys.items |> hd()
    assert key.key_id == 20_001
  end

  test "lists paginated keys" do
    keys =
      for i <- 1..2 do
        %{
          key_id: 20_000 + i,
          description: "Key #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      keys: keys
    }

    params = [page: 2, limit: 3]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "6"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "3"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %KeysCollection{} = keys} = Keys.all(@project_id, params)

    assert Enum.count(keys.items) == 2
    assert keys.total_count == 6
    assert keys.page_count == 2
    assert keys.per_page_limit == 3
    assert keys.current_page == 2
    assert keys.project_id == @project_id

    refute keys |> Pagination.first_page?()
    assert keys |> Pagination.last_page?()
    refute keys |> Pagination.next_page?()
    assert keys |> Pagination.prev_page?()

    key = hd(keys.items)
    assert key.key_id == 20_001
  end

  test "lists paginated with cursor keys" do
    keys =
      for i <- 1..2 do
        %{
          key_id: 20_000 + i,
          description: "Key #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      keys: keys
    }

    params = [limit: 2, pagination: "cursor", cursor: "100"]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-next-cursor", "200"},
        {"x-pagination-limit", "2"}
      ])
    end)

    {:ok, %KeysCollection{} = keys} =
      Keys.all(@project_id, params)

    assert Enum.count(keys.items) == 2
    assert keys.per_page_limit == 2
    assert keys.next_cursor == 200
  end

  test "finds a key" do
    key_id = 79_039_609

    response = %{
      project_id: @project_id,
      key: %{
        key_id: key_id,
        created_at: "2021-03-02 17:00:01 (Etc/UTC)",
        created_at_timestamp: 1_614_704_401,
        key_name: %{
          ios: "headline",
          android: "headline",
          web: "headline",
          other: "headline"
        },
        filenames: %{
          ios: "",
          android: "",
          web: "",
          other: ""
        },
        description: "",
        platforms: ["web"],
        tags: ["Home", "Personal", "Storyblok", "teaser"],
        comments: [],
        screenshots: [],
        translations: [
          %{
            translation_id: 566_314_684,
            key_id: key_id,
            language_iso: "en",
            translation: "Join our community!",
            modified_by: 20_181,
            modified_by_email: "user@example.com",
            modified_at: "2021-03-02 17:00:01 (Etc/UTC)",
            modified_at_timestamp: 1_614_704_401,
            is_reviewed: false,
            reviewed_by: 0,
            is_unverified: false,
            is_fuzzy: false,
            words: 3,
            custom_translation_statuses: [],
            task_id: nil
          }
        ],
        is_plural: false,
        plural_name: "",
        is_hidden: false,
        is_archived: false,
        context: "",
        base_words: 3,
        char_limit: 0,
        custom_attributes: "",
        modified_at: "2021-03-09 15:45:25 (Etc/UTC)",
        modified_at_timestamp: 1_615_304_725,
        translations_modified_at: "2021-03-09 15:45:34 (Etc/UTC)",
        translations_modified_at_timestamp: 1_615_304_734
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{key_id}")

      response
      |> ok()
    end)

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

  test "finds a key with params" do
    key_id = 79_039_609

    response = %{
      project_id: @project_id,
      key: %{
        key_id: key_id,
        created_at: "2021-03-02 17:00:01 (Etc/UTC)",
        created_at_timestamp: 1_614_704_401
      }
    }

    params = [disable_references: "1"]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{key_id}")

      req
      |> assert_get_params(params)

      response
      |> ok()
    end)

    {:ok, %KeyModel{} = key} = Keys.find(@project_id, key_id, params)

    assert key.key_id == key_id
  end

  test "creates a key" do
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

    response = %{
      project_id: @project_id,
      keys: [
        %{
          key_id: 1000,
          created_at: "2021-03-02 17:00:01 (Etc/UTC)",
          created_at_timestamp: 1_614_704_401,
          key_name: %{
            ios: "elixir_ios",
            android: "elixir",
            web: "elixir",
            other: "el_other"
          },
          description: "Via API",
          platforms: ["web", "android"],
          translations: [
            %{
              translation_id: 123,
              key_id: 1000,
              language_iso: "en",
              translation: "Hi from Elixir"
            },
            %{
              translation_id: 345,
              key_id: 1000,
              language_iso: "fr",
              translation: "test"
            }
          ]
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %KeysCollection{} = keys} = Keys.create(@project_id, data)

    key = hd(keys.items)
    assert key.key_name.android == "elixir"
    assert key.description == "Via API"
    assert List.first(key.translations).translation == "Hi from Elixir"
  end

  test "creates a key with error" do
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

    response = %{
      project_id: @project_id,
      keys: [
        %{
          key_id: 1000,
          created_at: "2021-03-02 17:00:01 (Etc/UTC)",
          created_at_timestamp: 1_614_704_401,
          key_name: %{
            ios: "elixir_ios",
            android: "elixir",
            web: "elixir",
            other: "el_other"
          },
          description: "Via API",
          platforms: ["web", "android"],
          translations: [
            %{
              translation_id: 123,
              key_id: 1000,
              language_iso: "en",
              translation: "Hi from Elixir"
            }
          ]
        }
      ],
      errors: [
        %{
          message: "This key name is already taken",
          code: 400,
          key_name: %{
            ios: "existing",
            android: "existing",
            web: "existing",
            other: "existing"
          }
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %KeysCollection{} = keys} = Keys.create(@project_id, data)

    key = keys.items |> List.first()
    assert key.key_name.android == "elixir"
    assert List.first(key.translations).translation == "Hi from Elixir"

    assert hd(keys.errors).message == "This key name is already taken"
  end

  test "updates a key" do
    key_id = 80_125_772

    data = %{
      description: "Updated via SDK",
      tags: ["sample"]
    }

    response = %{
      project_id: @project_id,
      key: %{
        key_id: key_id,
        description: "Updated via SDK",
        platforms: ["web"],
        tags: ["sample"],
        translations: [
          %{
            translation_id: 566_314_684,
            key_id: key_id,
            language_iso: "en",
            translation: "Join our community!"
          }
        ]
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{key_id}", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %KeyModel{} = key} = Keys.update(@project_id, key_id, data)

    assert key.key_id == key_id
    assert key.description == "Updated via SDK"
    assert key.tags == ["sample"]
  end

  test "updates keys in bulk" do
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

    response = %{
      project_id: @project_id,
      keys: [
        %{
          key_id: key_id,
          description: "Bulk updated via SDK",
          platforms: ["web"],
          tags: ["sample"],
          translations: [
            %{
              translation_id: 566_314_684,
              key_id: key_id,
              language_iso: "en",
              translation: "Join our community!"
            }
          ]
        },
        %{
          key_id: key_id2,
          description: "",
          platforms: ["web", "android"],
          translations: [
            %{
              translation_id: 566_314_685,
              key_id: key_id2,
              language_iso: "en",
              translation: "sample"
            }
          ]
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %KeysCollection{} = keys} = Keys.update_bulk(@project_id, data)

    assert Enum.count(keys.items) == 2
    [key1 | [key2 | []]] = keys.items

    assert key1.description == "Bulk updated via SDK"
    assert Enum.sort(key2.platforms) == ["android", "web"]
  end

  test "deletes a key" do
    key_id = 79_039_610

    response = %{
      project_id: @project_id,
      key_removed: true,
      keys_locked: 0
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{key_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Keys.delete(@project_id, key_id)

    assert resp.key_removed
    assert resp.project_id == @project_id
  end

  test "deletes keys in bulk" do
    data = %{
      keys: [
        80_125_772,
        79_039_609
      ]
    }

    response = %{
      project_id: @project_id,
      keys_removed: true,
      keys_locked: 0
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys", "DELETE")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Keys.delete_bulk(@project_id, data)

    assert resp.keys_removed
    assert resp.project_id == @project_id
  end
end
