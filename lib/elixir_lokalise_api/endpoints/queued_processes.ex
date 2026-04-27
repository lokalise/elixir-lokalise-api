defmodule ElixirLokaliseApi.QueuedProcesses do
  @moduledoc """
  Queued processes endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :all2, :find2]

  alias ElixirLokaliseApi.Collection.QueuedProcesses
  alias ElixirLokaliseApi.Model.QueuedProcess

  @model QueuedProcess
  @collection QueuedProcesses
  @endpoint "projects/{!:project_id}/processes/{:process_id}"
  @data_key :processes
  @singular_data_key :process
  @parent_key :project_id
  @item_key :process_id
end
