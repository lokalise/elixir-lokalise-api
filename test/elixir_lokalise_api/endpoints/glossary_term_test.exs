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

        glossary_terms |> IO.inspect()
      # assert Enum.count(translations.items) == 2
      # assert translations.per_page_limit == 2
      # assert translations.next_cursor == "eyIxIjozMDU0Mzg5ODQ2fQ=="
  end
  end
end
