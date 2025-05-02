defmodule ElixirLokaliseApi.GlossaryTermsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.GlossaryTerms
  alias ElixirLokaliseApi.Collection.GlossaryTerms, as: GlossaryTermsCollection
  alias ElixirLokaliseApi.Model.GlossaryTerm, as: GlossaryTermModel

  setup_all do
    HTTPoison.start()
  end

  doctest GlossaryTerms

  @project_id "6504960967ab53d45e0ed7.15877499"

  test "lists glossary terms with cursor" do
    use_cassette "glossary_terms_cursor" do
      {:ok, %GlossaryTermsCollection{} = glossary_terms} =
        GlossaryTerms.all(@project_id,
          limit: 2,
          cursor: "5319746"
        )

      assert Enum.count(glossary_terms.items) == 2
      assert glossary_terms.next_cursor == 5_489_104

      glossary_term = glossary_terms.items |> List.first()
      assert glossary_term.term == "sample term"
    end
  end

  test "finds a glossary term" do
    use_cassette "glossary_term_find" do
      term_id = 5_319_746
      {:ok, %GlossaryTermModel{} = glossary_term} = GlossaryTerms.find(@project_id, term_id)

      assert glossary_term.id == term_id
      assert glossary_term.projectId == @project_id
      assert glossary_term.term == "router"
      assert glossary_term.description == "A commonly used network device"
      refute glossary_term.caseSensitive
      assert glossary_term.translatable
      refute glossary_term.forbidden

      translation = hd(glossary_term.translations)
      assert translation[:langName] == "Russian"
      assert Enum.empty?(glossary_term.tags)
      assert glossary_term.createdAt == "2025-03-31 15:01:00 (Etc/UTC)"
      assert glossary_term.updatedAt == "2025-04-22 14:48:03 (Etc/UTC)"
    end
  end

  test "creates a glossary term" do
    use_cassette "glossary_terms_create" do
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

      {:ok, %GlossaryTermsCollection{} = glossary_terms} = GlossaryTerms.create(@project_id, data)

      glossary_term = hd(glossary_terms.items)

      assert glossary_term.term == "elixir"
      assert glossary_term.description == "language"
    end
  end

  test "updates glossary terms" do
    use_cassette "glossary_terms_update" do
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

      {:ok, %GlossaryTermsCollection{} = glossary_terms} =
        GlossaryTerms.update_bulk(@project_id, data)

      assert Enum.count(glossary_terms.items) == 2
      [term1 | [term2 | []]] = glossary_terms.items

      assert term2.tags == ["sample"]

      assert term1.caseSensitive
    end
  end

  test "deletes glossary terms in bulk" do
    use_cassette "glossary_terms_delete" do
      term_id = 5_520_368
      term_id2 = 5_511_072

      data = %{
        terms: [
          term_id,
          term_id2
        ]
      }

      {:ok, %{} = resp} = GlossaryTerms.delete_bulk(@project_id, data)

      assert resp[:data][:deleted][:count] == 2
    end
  end
end
