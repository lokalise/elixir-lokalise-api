defmodule ElixirLokaliseApi.Keys do
  @model ElixirLokaliseApi.Model.Key
  @collection ElixirLokaliseApi.Collection.Keys
  @endpoint "projects/{!:project_id}/keys/{:key_id}"
  @data_key :keys
  @singular_data_key :key
  @parent_key :project_id
  @item_key :key_id

  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :find2, :all2, :create2, :delete2, :update3, :update2_bulk, :delete2_bulk]
end
