defmodule ElixirLokaliseApi.Tasks do
  @model ElixirLokaliseApi.Model.Task
  @collection ElixirLokaliseApi.Collection.Tasks
  @endpoint "projects/{!:project_id}/tasks/{:task_id}"
  @data_key :tasks
  @singular_data_key :task
  @parent_key :project_id
  @item_key :task_id

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :create2, :update3, :delete2]
end
