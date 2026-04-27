defmodule ElixirLokaliseApi.Snapshots do
  @moduledoc """
  Snapshots endpoint.
  """
  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :foreign_model, :all2, :create2, :delete2]

  alias ElixirLokaliseApi.Collection.Snapshots
  alias ElixirLokaliseApi.Model.Project
  alias ElixirLokaliseApi.Model.Snapshot

  @model Snapshot
  @collection Snapshots
  @endpoint "projects/{!:project_id}/snapshots/{:snapshot_id}"
  @data_key :snapshots
  @singular_data_key :snapshot
  @parent_key :project_id
  @item_key :snapshot_id
  @foreign_model Project
  @foreign_data_key nil

  def restore(project_id, snapshot_id) do
    make_request(:post,
      url_params: url_params(project_id, snapshot_id),
      type: :foreign_model
    )
  end
end
