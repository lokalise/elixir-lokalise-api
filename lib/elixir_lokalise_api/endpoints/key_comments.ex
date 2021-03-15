defmodule ElixirLokaliseApi.KeyComments do
  @model ElixirLokaliseApi.Model.Comment
  @collection ElixirLokaliseApi.Collection.Comments
  @endpoint "projects/{!:project_id}/keys/{!:key_id}/comments/{:comment_id}"
  @data_key :comments
  @singular_data_key :comment
  @parent_key :project_id
  @item_key :key_id
  @subitem_key :comment_id

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :subitem_reader, :find3, :all3, :create3, :delete3]
end
