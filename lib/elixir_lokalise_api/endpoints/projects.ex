defmodule ElixirLokaliseApi.Projects do
  @model ElixirLokaliseApi.Model.Project
  @collection ElixirLokaliseApi.Collection.Projects
  @endpoint "projects/"
  @data_key :projects

  use ElixirLokaliseApi.DynamicResource, import: [:find, :all]

  def model, do: @model

  def collection, do: @collection

  def data_key, do: @data_key

  def path_for(nil), do: @endpoint

  def path_for(id) do
    @endpoint <> id
  end
end
