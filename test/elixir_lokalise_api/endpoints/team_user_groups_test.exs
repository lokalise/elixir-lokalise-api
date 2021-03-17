defmodule ElixirLokaliseApi.TeamUserGroupsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TeamUserGroups
  alias ElixirLokaliseApi.Model.TeamUserGroup, as: TeamUserGroupModel
  alias ElixirLokaliseApi.Collection.TeamUserGroups, as: TeamUserGroupsCollection

  setup_all do
    HTTPoison.start()
  end

  doctest TeamUserGroups

  @team_id 176_692
  @group_id 3991
  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all team user groups" do
    use_cassette "team_user_groups_all" do
      {:ok, %TeamUserGroupsCollection{} = groups} = TeamUserGroups.all(@team_id)
      assert groups.team_id == @team_id
      assert Enum.count(groups.items) == 7

      group = hd(groups.items)
      assert group.group_id == 2639
    end
  end

  test "lists paginated team user groups" do
    use_cassette "team_user_groups_all_paginated" do
      {:ok, %TeamUserGroupsCollection{} = groups} =
        TeamUserGroups.all(@team_id, page: 3, limit: 2)

      assert groups.team_id == @team_id

      assert Enum.count(groups.items) == 2
      assert groups.total_count == 7
      assert groups.page_count == 4
      assert groups.per_page_limit == 2
      assert groups.current_page == 3

      refute groups |> Pagination.first_page?()
      refute groups |> Pagination.last_page?()
      assert groups |> Pagination.next_page?()
      assert groups |> Pagination.prev_page?()

      group = hd(groups.items)
      assert group.group_id == 3274
    end
  end

  test "finds a team user group" do
    use_cassette "team_user_group_find" do
      group_id = 3274
      {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.find(@team_id, group_id)

      assert group.group_id == group_id
      assert group.name == "Russian contributors"
      refute group.permissions.is_admin
      assert group.created_at == "2020-11-04 16:29:16 (Etc/UTC)"
      assert group.created_at_timestamp == 1_604_507_356
      assert group.team_id == @team_id
      assert group.projects == []
      assert group.members == [35554]
    end
  end

  test "creates a team user group" do
    use_cassette "team_user_group_create" do
      data = %{
        name: "ExGroup",
        is_reviewer: true,
        is_admin: false,
        languages: %{
          reference: [],
          contributable: [640]
        }
      }

      {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.create(@team_id, data)

      assert group.name == "ExGroup"
      refute group.permissions.is_admin
      assert group.permissions.is_reviewer
    end
  end

  test "updates a team user group" do
    use_cassette "team_user_group_update" do
      data = %{
        name: "ExGroup Updated",
        is_reviewer: true,
        is_admin: false,
        languages: %{
          reference: [],
          contributable: [640]
        }
      }

      {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.update(@team_id, @group_id, data)

      assert group.name == "ExGroup Updated"
      refute group.permissions.is_admin
      assert group.permissions.is_reviewer
    end
  end

  test "deletes a team user group" do
    use_cassette "team_user_group_delete" do
      group_id = 3274
      {:ok, %{} = resp} = TeamUserGroups.delete(@team_id, group_id)

      assert resp.team_id == @team_id
      assert resp.group_deleted
    end
  end

  test "adds projects to a team user group" do
    use_cassette "team_user_group_add_project" do
      data = %{
        projects: [@project_id]
      }

      {:ok, %TeamUserGroupModel{} = group} =
        TeamUserGroups.add_projects(@team_id, @group_id, data)

      assert group.group_id == @group_id
      assert group.projects == [@project_id]
    end
  end

  test "removes projects from a team user group" do
    use_cassette "team_user_group_remove_project" do
      data = %{
        projects: [@project_id]
      }

      {:ok, %TeamUserGroupModel{} = group} =
        TeamUserGroups.remove_projects(@team_id, @group_id, data)

      assert group.group_id == @group_id
      assert group.projects == []
    end
  end

  test "adds members to a team user group" do
    use_cassette "team_user_group_add_members" do
      user_id = 20181

      data = %{
        users: [user_id]
      }

      {:ok, %TeamUserGroupModel{} = group} = TeamUserGroups.add_members(@team_id, @group_id, data)

      assert group.group_id == @group_id
      assert group.members == [user_id]
    end
  end

  test "removes members to a team user group" do
    use_cassette "team_user_group_remove_members" do
      user_id = 20181

      data = %{
        users: [user_id]
      }

      {:ok, %TeamUserGroupModel{} = group} =
        TeamUserGroups.remove_members(@team_id, @group_id, data)

      assert group.group_id == @group_id
      assert group.members == []
    end
  end
end
