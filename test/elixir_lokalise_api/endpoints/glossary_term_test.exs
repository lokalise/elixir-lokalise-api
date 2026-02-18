defmodule ElixirLokaliseApi.GlossaryTermsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.GlossaryTerms
  alias ElixirLokaliseApi.Collection.GlossaryTerms, as: GlossaryTermsCollection
  alias ElixirLokaliseApi.Model.GlossaryTerm, as: GlossaryTermModel

  doctest GlossaryTerms

  @project_id "6504960967ab53d45e0ed7.15877499"

  test "lists glossary terms with cursor" do
    languages = [
      {1, "lv", "Latvian"},
      {2, "en", "English"},
      {3, "fr_CA", "French (Canada)"}
    ]

    fake_translation = fn {id, iso, name} ->
      %{
        langId: id,
        langName: name,
        langIso: iso,
        translation: "",
        description: ""
      }
    end

    fake_term = fn id, term_name, case_sensitive ->
      %{
        id: id,
        term: term_name,
        description: "Description for #{term_name}",
        caseSensitive: case_sensitive,
        translatable: false,
        forbidden: false,
        translations: Enum.map(languages, fake_translation),
        tags: [],
        projectId: @project_id,
        createdAt: "2024-01-01 00:00:00 (Etc/UTC)",
        updatedAt: nil
      }
    end

    terms_response = %{
      data: [
        fake_term.(1, "sample term", false),
        fake_term.(2, "HTML", true)
      ],
      meta: %{
        count: 2,
        limit: 2,
        cursor: 100,
        hasMore: true,
        nextCursor: 200
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/glossary-terms")

      terms_response
      |> ok([{"x-pagination-next-cursor", "200"}])
    end)

    {:ok, %GlossaryTermsCollection{} = glossary_terms} =
      GlossaryTerms.all(@project_id,
        limit: 2,
        cursor: 100
      )

    assert Enum.count(glossary_terms.items) == 2
    assert glossary_terms.next_cursor == 200

    glossary_term = glossary_terms.items |> List.first()
    assert glossary_term.term == "sample term"
  end

  test "finds a glossary term" do
    term_id = 5_319_746

    languages = [
      {1, "lv", "Latvian"},
      {2, "en", "English"},
      {3, "fr_CA", "French (Canada)"}
    ]

    translations =
      Enum.map(languages, fn {id, iso, name} ->
        %{
          langId: id,
          langName: name,
          langIso: iso,
          translation: "",
          description: ""
        }
      end)

    term_response = %{
      data: %{
        id: term_id,
        term: "router",
        description: "A commonly used network device",
        caseSensitive: false,
        translatable: true,
        forbidden: false,
        translations: translations,
        tags: [],
        projectId: @project_id,
        createdAt: "2024-01-01 00:00:00 (Etc/UTC)",
        updatedAt: "2024-01-02 00:00:00 (Etc/UTC)"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/glossary-terms/#{term_id}")

      term_response
      |> ok()
    end)

    {:ok, %GlossaryTermModel{} = glossary_term} = GlossaryTerms.find(@project_id, term_id)

    assert glossary_term.id == term_id
    assert glossary_term.projectId == @project_id
    assert glossary_term.term == "router"
    assert glossary_term.description == "A commonly used network device"
    refute glossary_term.caseSensitive
    assert glossary_term.translatable
    refute glossary_term.forbidden

    translation = hd(glossary_term.translations)
    assert translation[:langName] == "Latvian"
    assert Enum.empty?(glossary_term.tags)
    assert glossary_term.createdAt == "2024-01-01 00:00:00 (Etc/UTC)"
    assert glossary_term.updatedAt == "2024-01-02 00:00:00 (Etc/UTC)"
  end

  test "creates a glossary term" do
    data = %{
      terms: [
        %{
          term: "elixir",
          description: "language",
          caseSensitive: false,
          translatable: false,
          forbidden: false
        }
      ]
    }

    languages = [
      {1, "lv", "Latvian"},
      {2, "en", "English"},
      {3, "fr_CA", "French (Canada)"}
    ]

    translations =
      Enum.map(languages, fn {id, iso, name} ->
        %{
          langId: id,
          langName: name,
          langIso: iso,
          translation: "",
          description: ""
        }
      end)

    term = %{
      id: 1,
      term: "elixir",
      description: "language",
      caseSensitive: false,
      translatable: false,
      forbidden: false,
      translations: translations,
      tags: [],
      projectId: @project_id,
      createdAt: "2024-01-01 00:00:00 (Etc/UTC)",
      updatedAt: nil
    }

    terms_response = %{
      data: [term],
      meta: %{
        count: 1,
        created: 1,
        limit: 500
      },
      errors: []
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/glossary-terms", "POST")

      req |> assert_json_body(data)

      terms_response
      |> ok()
    end)

    {:ok, %GlossaryTermsCollection{} = glossary_terms} = GlossaryTerms.create(@project_id, data)

    glossary_term = hd(glossary_terms.items)

    assert glossary_term.term == "elixir"
    assert glossary_term.description == "language"
  end

  test "updates glossary terms" do
    term_id = 5_520_368
    term_id2 = 5_511_072

    data = %{
      terms: [
        %{
          id: term_id,
          description: "elixir updated",
          tags: ["sample"]
        },
        %{
          id: term_id2,
          caseSensitive: true
        }
      ]
    }

    languages = [
      {1, "lv", "Latvian"},
      {2, "en", "English"},
      {3, "fr_CA", "French (Canada)"}
    ]

    translations =
      Enum.map(languages, fn {id, iso, name} ->
        %{
          langId: id,
          langName: name,
          langIso: iso,
          translation: "",
          description: ""
        }
      end)

    fake_term = fn id, term_name, opts ->
      %{
        id: id,
        term: term_name,
        description: opts[:description] || "desc",
        caseSensitive: opts[:case_sensitive] || false,
        translatable: opts[:translatable] || false,
        forbidden: opts[:forbidden] || false,
        translations: translations,
        tags: opts[:tags] || [],
        projectId: "fake_project_id",
        createdAt: "2024-01-01 00:00:00 (Etc/UTC)",
        updatedAt: opts[:updated_at]
      }
    end

    terms_response = %{
      data: [
        fake_term.(term_id, "test",
          description: "test",
          case_sensitive: true,
          translatable: true,
          forbidden: true
        ),
        fake_term.(term_id2, "elixir",
          description: "elixir updated",
          tags: ["sample"],
          updated_at: "2024-01-02 00:00:00 (Etc/UTC)"
        )
      ],
      meta: %{
        count: 2,
        updated: 1,
        limit: 500
      },
      errors: []
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/glossary-terms", "PUT")

      req |> assert_json_body(data)

      terms_response
      |> ok()
    end)

    {:ok, %GlossaryTermsCollection{} = glossary_terms} =
      GlossaryTerms.update_bulk(@project_id, data)

    assert Enum.count(glossary_terms.items) == 2
    [term1 | [term2 | []]] = glossary_terms.items

    assert term2.tags == ["sample"]

    assert term1.caseSensitive
  end

  test "deletes glossary terms in bulk" do
    term_id = 5_520_368
    term_id2 = 5_511_072

    data = %{
      terms: [
        term_id,
        term_id2
      ]
    }

    delete_response = %{
      data: %{
        deleted: %{
          count: 2,
          ids: [term_id, term_id2]
        }
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/glossary-terms", "DELETE")

      req |> assert_json_body(data)

      delete_response
      |> ok()
    end)

    {:ok, %{} = resp} = GlossaryTerms.delete_bulk(@project_id, data)

    assert resp[:data][:deleted][:count] == 2
  end
end
