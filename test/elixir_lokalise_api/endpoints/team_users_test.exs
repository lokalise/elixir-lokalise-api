defmodule ElixirLokaliseApi.TeamUsersTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TeamUsers
  alias ElixirLokaliseApi.Model.TeamUser, as: TeamUserModel
  alias ElixirLokaliseApi.Collection.TeamUsers, as: TeamUsersCollection

  setup_all do
    HTTPoison.start()
  end

  doctest TeamUsers

  @team_id 218_347

  test "lists all team users" do
    use_cassette "team_users_all" do
      {:ok, %TeamUsersCollection{} = users} = TeamUsers.all(@team_id)

      assert Enum.count(users.items) == 2
      assert users.team_id == @team_id

      user = hd(users.items)
      assert user.user_id == 72008
    end
  end

  test "lists paginated team users" do
    use_cassette "team_users_all_paginated" do
      {:ok, %TeamUsersCollection{} = users} = TeamUsers.all(@team_id, limit: 1, page: 2)

      assert Enum.count(users.items) == 1
      assert users.team_id == @team_id
      assert users.total_count == 2
      assert users.page_count == 2
      assert users.per_page_limit == 1
      assert users.current_page == 2

      refute users |> Pagination.first_page?()
      assert users |> Pagination.last_page?()
      refute users |> Pagination.next_page?()
      assert users |> Pagination.prev_page?()

      user = hd(users.items)
      assert user.user_id == 20181
    end
  end

  test "finds a team user" do
    use_cassette "team_user_find" do
      user_id = 20181
      {:ok, %TeamUserModel{} = user} = TeamUsers.find(@team_id, user_id)

      assert user.user_id == user_id
      assert user.email == "bodrovis@protonmail.com"
      assert user.fullname == "Ilya B"
      assert user.created_at == "2018-08-21 15:35:25 (Etc/UTC)"
      assert user.created_at_timestamp == 1534865725
      assert user.role == "owner"
    end
  end

  test "updates a team user" do
    use_cassette "team_user_update" do
      user_id = 72008
      data = %{
        role: "admin"
      }
      {:ok, %TeamUserModel{} = user} = TeamUsers.update(@team_id, user_id, data)

      assert user.user_id == user_id
      assert user.role == "admin"
    end
  end

  test "deletes a team user" do
    use_cassette "team_user_delete" do
      user_id = 72008
      {:ok, %{} = resp} = TeamUsers.delete(@team_id, user_id)

      assert resp.team_id == @team_id
      assert resp.team_user_deleted
    end
  end
end
