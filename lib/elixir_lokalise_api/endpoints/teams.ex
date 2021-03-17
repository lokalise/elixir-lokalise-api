defmodule ElixirLokaliseApi.Teams do
  @moduledoc """
  Teams endpoint.
  """
  @model ElixirLokaliseApi.Model.Team
  @collection ElixirLokaliseApi.Collection.Teams
  @endpoint "teams/"
  @data_key :teams
  @singular_data_key nil
  @parent_key nil

  use ElixirLokaliseApi.DynamicResource, import: [:all]
end
