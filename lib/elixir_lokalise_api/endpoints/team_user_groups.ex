defmodule ElixirLokaliseApi.TeamUserGroups do
  @model ElixirLokaliseApi.Model.TeamUserGroup
  @collection ElixirLokaliseApi.Collection.TeamUserGroups
  @endpoint "teams/{!:team_id}/groups/{:group_id}/{:_postfix}"
  @data_key :user_groups
  @singular_data_key :group
  @parent_key :team_id
  @item_key :group_id

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :create2, :update3, :delete2]

  def add_projects(project_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(project_id, group_id) ++ [{:_postfix, "projects/add"}]
    )
  end

  def remove_projects(project_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(project_id, group_id) ++ [{:_postfix, "projects/remove"}]
    )
  end

  def add_members(project_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(project_id, group_id) ++ [{:_postfix, "members/add"}]
    )
  end

  def remove_members(project_id, group_id, data) do
    make_request(:put,
      data: data,
      url_params: url_params(project_id, group_id) ++ [{:_postfix, "members/remove"}]
    )
  end
end
