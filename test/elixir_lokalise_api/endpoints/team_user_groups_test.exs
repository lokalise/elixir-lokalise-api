defmodule ElixirLokaliseApi.TeamUserGroupsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TeamUserGroups
  alias ElixirLokaliseApi.Model.TeamUserGroup, as: TeamUserGroupModel
  alias ElixirLokaliseApi.Collection.TeamUserGroups, as: TeamUserGroupsCollection

  doctest TeamUserGroups

  @team_id 176_692
  @group_id 3991
  @user_id 20_181
  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all team user groups" do
    groups =
      for i <- 1..5 do
        %{
          group_id: 1000 + i,
          name: "Group #{i}",
          team_id: @team_id,
          members: [30_000 + i]
        }
      end

    response = %{
      team_id: @team_id,
      user_groups: groups
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups")

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupsCollection{} = groups} = TeamUserGroups.all(@team_id)
    assert groups.team_id == @team_id
    assert Enum.count(groups.items) == 5

    group = hd(groups.items)
    assert group.group_id == 1001
  end

  test "lists paginated team user groups" do
    groups =
      for i <- 1..3 do
        %{
          group_id: 1000 + i,
          name: "Group #{i}",
          team_id: @team_id,
          projects: [],
          members: [30_000 + i]
        }
      end

    response = %{
      team_id: @team_id,
      user_groups: groups
    }

    params = [page: 3, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "6"},
        {"x-pagination-page-count", "3"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "3"}
      ])
    end)

    {:ok, %TeamUserGroupsCollection{} = groups} =
      TeamUserGroups.all(@team_id, params)

    assert groups.team_id == @team_id

    assert Enum.count(groups.items) == 3
    assert groups.total_count == 6
    assert groups.page_count == 3
    assert groups.per_page_limit == 2
    assert groups.current_page == 3

    refute groups |> Pagination.first_page?()
    assert groups |> Pagination.last_page?()
    refute groups |> Pagination.next_page?()
    assert groups |> Pagination.prev_page?()

    group = hd(groups.items)
    assert group.group_id == 1001
  end

  test "finds a team user group" do
    response = %{
      group_id: @group_id,
      name: "My group",
      permissions: %{
        is_admin: false,
        is_reviewer: false,
        admin_rights: ["download", "keys"],
        languages: [
          %{
            lang_id: 640,
            lang_iso: "en",
            lang_name: "English",
            is_writable: true
          }
        ]
      },
      created_at: "2020-11-04 16:29:16 (Etc/UTC)",
      created_at_timestamp: 1_604_507_356,
      team_id: @team_id,
      projects: [],
      members: [30_000],
      role_id: 5
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups/#{@group_id}")

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.find(@team_id, @group_id)

    assert group.group_id == @group_id
    assert group.name == "My group"
    refute group.permissions.is_admin
    assert group.created_at == "2020-11-04 16:29:16 (Etc/UTC)"
    assert group.created_at_timestamp == 1_604_507_356
    assert group.team_id == @team_id
    assert group.projects == []
    assert group.members == [30_000]
    assert group.role_id == 5
  end

  test "creates a team user group" do
    data = %{
      name: "ExGroup",
      is_reviewer: true,
      is_admin: false,
      languages: %{
        reference: [],
        contributable: [640]
      }
    }

    response = %{
      group_id: 1234,
      name: "ExGroup"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.create(@team_id, data)

    assert group.name == "ExGroup"
  end

  test "updates a team user group" do
    data = %{
      name: "ExGroup Updated",
      is_reviewer: true,
      is_admin: false,
      languages: %{
        reference: [],
        contributable: [640]
      }
    }

    response = %{
      group_id: @group_id,
      name: "ExGroup Updated",
      permissions: %{
        is_admin: false,
        is_reviewer: true
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups/#{@group_id}", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.update(@team_id, @group_id, data)

    assert group.name == "ExGroup Updated"
    refute group.permissions.is_admin
    assert group.permissions.is_reviewer
  end

  test "deletes a team user group" do
    response = %{
      team_id: @team_id,
      group_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups/#{@group_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = TeamUserGroups.delete(@team_id, @group_id)

    assert resp.team_id == @team_id
    assert resp.group_deleted
  end

  test "adds projects to a team user group" do
    data = %{
      projects: [@project_id]
    }

    response = %{
      team_id: @team_id,
      group: %{
        group_id: @group_id,
        projects: [@project_id],
        members: []
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups/#{@group_id}/projects/add", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupModel{} = group} =
      TeamUserGroups.add_projects(@team_id, @group_id, data)

    assert group.group_id == @group_id
    assert group.projects == [@project_id]
  end

  test "removes projects from a team user group" do
    data = %{
      projects: [@project_id]
    }

    response = %{
      team_id: @team_id,
      group: %{
        group_id: @group_id,
        projects: [],
        members: []
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups/#{@group_id}/projects/remove", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupModel{} = group} =
      TeamUserGroups.remove_projects(@team_id, @group_id, data)

    assert group.group_id == @group_id
    assert group.projects == []
  end

  test "adds members to a team user group" do
    data = %{
      users: [@user_id]
    }

    response = %{
      team_id: @team_id,
      group: %{
        group_id: @group_id,
        members: [@user_id]
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups/#{@group_id}/members/add", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.add_members(@team_id, @group_id, data)

    assert group.group_id == @group_id
    assert group.members == [@user_id]
  end

  test "removes members to a team user group" do
    data = %{
      users: [@user_id]
    }

    response = %{
      team_id: @team_id,
      group: %{
        group_id: @group_id,
        members: []
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/groups/#{@group_id}/members/remove", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TeamUserGroupModel{} = group} =
      TeamUserGroups.remove_members(@team_id, @group_id, data)

    assert group.group_id == @group_id
    assert group.members == []
  end
end
