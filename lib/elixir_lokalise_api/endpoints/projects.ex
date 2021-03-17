defmodule ElixirLokaliseApi.Projects do
  @moduledoc """
  Projects endpoint.
  """
  @model ElixirLokaliseApi.Model.Project
  @collection ElixirLokaliseApi.Collection.Projects
  @endpoint "projects/{:project_id}/{:_postfix}"
  @data_key :projects
  @singular_data_key nil
  @parent_key :project_id

  use ElixirLokaliseApi.DynamicResource, import: [:find, :all, :create, :delete, :update2]

  @doc """
  Empties a given project by removing all translation keys and values.
  """
  def empty(project_id) do
    make_request(:put,
      url_params: url_params(project_id) ++ [{:_postfix, "empty"}],
      type: :raw
    )
  end
end
