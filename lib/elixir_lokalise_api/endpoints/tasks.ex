defmodule ElixirLokaliseApi.Tasks do
  @moduledoc """
  Tasks endpoint.
  """
  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :create2, :update3, :delete2]

  alias ElixirLokaliseApi.Collection.Tasks

  @model ElixirLokaliseApi.Model.Task
  @collection Tasks
  @endpoint "projects/{!:project_id}/tasks/{:task_id}"
  @data_key :tasks
  @singular_data_key :task
  @parent_key :project_id
  @item_key :task_id
end
