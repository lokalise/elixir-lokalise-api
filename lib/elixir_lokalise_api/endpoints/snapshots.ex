defmodule ElixirLokaliseApi.Snapshots do
  @moduledoc """
  Snapshots endpoint.
  """
  @model ElixirLokaliseApi.Model.Snapshot
  @collection ElixirLokaliseApi.Collection.Snapshots
  @endpoint "projects/{!:project_id}/snapshots/{:snapshot_id}"
  @data_key :snapshots
  @singular_data_key :snapshot
  @parent_key :project_id
  @item_key :snapshot_id
  @foreign_model ElixirLokaliseApi.Model.Project
  @foreign_data_key nil

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :foreign_model, :all2, :create2, :delete2]

  def restore(project_id, snapshot_id) do
    make_request(:post,
      url_params: url_params(project_id, snapshot_id),
      type: :foreign_model
    )
  end
end
