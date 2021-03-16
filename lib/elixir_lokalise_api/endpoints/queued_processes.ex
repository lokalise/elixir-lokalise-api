defmodule ElixirLokaliseApi.QueuedProcesses do
  @model ElixirLokaliseApi.Model.QueuedProcess
  @collection ElixirLokaliseApi.Collection.QueuedProcesses
  @endpoint "projects/{!:project_id}/processes/{:process_id}"
  @data_key :processes
  @singular_data_key :process
  @parent_key :project_id
  @item_key :process_id

  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :all2, :find2]
end
