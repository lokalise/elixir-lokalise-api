defmodule ElixirLokaliseApi.Branches do
  @moduledoc """
  Branches endpoint.
  """

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :find2, :all2, :create2, :delete2, :update3]

  alias ElixirLokaliseApi.Collection.Branches
  alias ElixirLokaliseApi.Model.Branch

  @model Branch
  @collection Branches
  @endpoint "projects/{!:project_id}/branches/{:branch_id}/{:_postfix}"
  @data_key :branches
  @singular_data_key :branch
  @parent_key :project_id
  @item_key :branch_id

  @doc """
  Merges two branches inside the given project.
  """
  def merge(project_id, branch_id, data \\ %{}) do
    make_request(:post,
      data: data,
      url_params: url_params(project_id, branch_id) ++ [{:_postfix, "merge"}],
      type: :raw
    )
  end
end
