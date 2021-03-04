defmodule ElixirLokaliseApi.Projects do
  @model ElixirLokaliseApi.Model.Project
  @collection ElixirLokaliseApi.Collection.Projects
  @endpoint "projects/{:project_id}/{:_postfix}"
  @data_key :projects
  @parent_key :project_id

  use ElixirLokaliseApi.DynamicResource, import: [:find, :all, :create, :delete, :update]

  def empty(id) do
    Request.put(__MODULE__, [
      url_params: [{parent_key(), id}, {:_postfix, "empty"}],
      type: :raw
    ])
  end
end
