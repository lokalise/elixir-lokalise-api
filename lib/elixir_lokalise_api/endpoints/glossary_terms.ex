defmodule ElixirLokaliseApi.GlossaryTerms do
  @moduledoc """
  GlossaryTerms endpoint.
  """
  @model ElixirLokaliseApi.Model.GlossaryTerm
  @collection ElixirLokaliseApi.Collection.GlossaryTerms
  @endpoint "projects/{!:project_id}/glossary-terms/{:term_id}/"
  @data_key :data
  @singular_data_key :data
  @parent_key :project_id
  @item_key :id

  use ElixirLokaliseApi.DynamicResource,
    import: [
      :item_reader,
      :find2,
      :all2,
      :create2,
      :update2_bulk,
      :delete2_bulk
    ]
end
