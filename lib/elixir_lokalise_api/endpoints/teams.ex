defmodule ElixirLokaliseApi.Teams do
  @moduledoc """
  Teams endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:all, :find]

  alias ElixirLokaliseApi.Collection.Teams
  alias ElixirLokaliseApi.Model.Team

  @model Team
  @collection Teams
  @endpoint "teams/{:team_id}"
  @data_key :teams
  @singular_data_key :team
  @parent_key :team_id
end
