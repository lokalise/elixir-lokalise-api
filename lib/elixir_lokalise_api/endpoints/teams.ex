defmodule ElixirLokaliseApi.Teams do
  @moduledoc """
  Teams endpoint.
  """
  @model ElixirLokaliseApi.Model.Team
  @collection ElixirLokaliseApi.Collection.Teams
  @endpoint "teams/{:team_id}"
  @data_key :teams
  @singular_data_key :team
  @parent_key :team_id

  use ElixirLokaliseApi.DynamicResource, import: [:all, :find]
end
