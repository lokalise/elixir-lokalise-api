defmodule ElixirLokaliseApi.Projects do
  @model ElixirLokaliseApi.Model.Project
  @collection ElixirLokaliseApi.Collection.Projects
  @endpoint "projects/{:project_id}/{:_postfix}"
  @data_key :projects
  @singular_data_key nil
  @parent_key :project_id

  use ElixirLokaliseApi.DynamicResource, import: [:find, :all, :create, :delete, :update2]

  def empty(id) do
    make_request(:put,
      url_params: url_params(id) ++ [ {:_postfix, "empty"} ],
      type: :raw
    )
  end
end
