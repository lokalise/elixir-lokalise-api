defmodule ElixirLokaliseApi.TeamUserGroups do
  @moduledoc """
  Team user groups endpoint.
  """
  @model ElixirLokaliseApi.Model.TeamUserGroup
  @collection ElixirLokaliseApi.Collection.TeamUserGroups
  @endpoint "teams/{!:team_id}/groups/{:group_id}/{:_postfix}"
  @data_key :user_groups
  @singular_data_key :group
  @parent_key :team_id
  @item_key :group_id

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :create2, :update3, :delete2]

  @doc """
  Adds projects to the given group.
  """
  def add_projects(team_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(team_id, group_id) ++ [{:_postfix, "projects/add"}]
    )
  end

  @doc """
  Removes projects from the given group.
  """
  def remove_projects(team_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(team_id, group_id) ++ [{:_postfix, "projects/remove"}]
    )
  end

  @doc """
  Adds members to the given group.
  """
  def add_members(team_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(team_id, group_id) ++ [{:_postfix, "members/add"}]
    )
  end

  @doc """
  Removes members from the given group.
  """
  def remove_members(team_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(team_id, group_id) ++ [{:_postfix, "members/remove"}]
    )
  end
end
