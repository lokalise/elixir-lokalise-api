defmodule ElixirLokaliseApi.Model.GlossaryTerm do
  @moduledoc false
  defstruct id: nil,
            projectId: nil,
            term: nil,
            description: nil,
            caseSensitive: nil,
            translatable: nil,
            forbidden: nil,
            translations: %{},
            tags: [],
            createdAt: nil,
            updatedAt: nil
end
