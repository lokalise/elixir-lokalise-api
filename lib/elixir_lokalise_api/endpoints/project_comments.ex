defmodule ElixirLokaliseApi.ProjectComments do
  @moduledoc """
  Project comments endpoint.
  """
  @model ElixirLokaliseApi.Model.Comment
  @collection ElixirLokaliseApi.Collection.Comments
  @endpoint "projects/{!:project_id}/comments"
  @data_key :comments
  @singular_data_key :comment
  @parent_key :project_id

  use ElixirLokaliseApi.DynamicResource, import: [:all2]
end
