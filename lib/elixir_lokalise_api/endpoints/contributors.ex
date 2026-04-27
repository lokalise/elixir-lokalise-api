defmodule ElixirLokaliseApi.Contributors do
  @moduledoc """
  Contributors endpoint.
  """

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :find2, :all2, :create2, :delete2, :update3]

  alias ElixirLokaliseApi.Collection.Contributors
  alias ElixirLokaliseApi.Model.Contributor

  @model Contributor
  @collection Contributors
  @endpoint "projects/{!:project_id}/contributors/{:contributor_id}"
  @data_key :contributors
  @singular_data_key :contributor
  @parent_key :project_id
  @item_key :contributor_id

  def me(project_id) do
    make_request(:get,
      url_params: url_params(project_id, :me)
    )
  end
end
