defmodule ElixirLokaliseApi.Segments do
  @moduledoc """
  Segments endpoint.
  """
  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :subitem_reader, :child_reader, :find4, :all4, :update5]

  alias ElixirLokaliseApi.Collection.Segments
  alias ElixirLokaliseApi.Model.Segment

  @model Segment
  @collection Segments
  @endpoint "projects/{!:project_id}/keys/{!:key_id}/segments/{!:lang_iso}/{:segment_number}"
  @data_key :segments
  @singular_data_key :segment
  @parent_key :project_id
  @item_key :key_id
  @subitem_key :lang_iso
  @child_key :segment_number
end
