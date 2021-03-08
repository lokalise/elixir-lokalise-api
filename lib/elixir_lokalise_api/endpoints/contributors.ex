defmodule ElixirLokaliseApi.Contributors do
  @model ElixirLokaliseApi.Model.Contributor
  @collection ElixirLokaliseApi.Collection.Contributors
  @endpoint "projects/{!:project_id}/contributors/{:contributor_id}"
  @data_key :contributors
  @singular_data_key :contributor
  @parent_key :project_id
  @item_key :contributor_id

  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :find2, :all2, :create2, :delete2, :update3]
end
