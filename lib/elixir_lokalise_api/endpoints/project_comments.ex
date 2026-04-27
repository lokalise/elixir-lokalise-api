defmodule ElixirLokaliseApi.ProjectComments do
  @moduledoc """
  Project comments endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:all2]

  alias ElixirLokaliseApi.Collection.Comments
  alias ElixirLokaliseApi.Model.Comment

  @model Comment
  @collection Comments
  @endpoint "projects/{!:project_id}/comments"
  @data_key :comments
  @singular_data_key :comment
  @parent_key :project_id
end
