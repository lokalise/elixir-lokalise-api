defmodule ElixirLokaliseApi.GlossaryTerms do
  @moduledoc """
  GlossaryTerms endpoint.
  """
  @model ElixirLokaliseApi.Model.GlossaryTerm
  @collection ElixirLokaliseApi.Collection.GlossaryTerms
  @endpoint "projects/{!:project_id}/glossary-terms/{:term_id}"
  @data_key :data
  @singular_data_key :data
  @parent_key :project_id
  @item_key :term_id

  use ElixirLokaliseApi.DynamicResource,
    import: [
      :item_reader,
      :all2,
      :create2,
      :update2_bulk,
      :delete2_bulk
    ]

  def find(parent_id, item_id) do
    make_request(:get,
      url_params: url_params(parent_id, item_id),
      type: :current_model
    )
  end
end
