defmodule ElixirLokaliseApi.TeamUsersTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.TeamUsers, as: TeamUsersCollection
  alias ElixirLokaliseApi.Model.TeamUser, as: TeamUserModel
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TeamUsers

  doctest TeamUsers

  @team_id 218_347
  @user_id 20_181

  test "lists all team users" do
    users =
      for i <- 1..3 do
        %{
          user_id: 20_000 + i,
          email: "user#{i}@example.com",
          fullname: "User #{i}",
          created_at: "2020-01-01 00:00:0#{i} (Etc/UTC)",
          created_at_timestamp: 1_600_000_000 + i,
          role: if(i == 1, do: "owner", else: "member")
        }
      end

    response = %{
      team_id: @team_id,
      team_users: users
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/users")

      response
      |> ok()
    end)

    {:ok, %TeamUsersCollection{} = users} = TeamUsers.all(@team_id)

    assert Enum.count(users.items) == 3
    assert users.team_id == @team_id

    user = hd(users.items)
    assert user.user_id == 20_001
  end

  test "lists paginated team users" do
    users =
      for i <- 1..2 do
        %{
          user_id: 20_000 + i,
          email: "user#{i}@example.com",
          fullname: "User #{i}",
          created_at: "2020-01-01 00:00:0#{i} (Etc/UTC)",
          created_at_timestamp: 1_600_000_000 + i,
          role: if(i == 1, do: "owner", else: "member")
        }
      end

    response = %{
      team_id: @team_id,
      team_users: users
    }

    params = [limit: 2, page: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/users")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "5"},
        {"x-pagination-page-count", "3"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %TeamUsersCollection{} = users} = TeamUsers.all(@team_id, params)

    assert Enum.count(users.items) == 2
    assert users.team_id == @team_id
    assert users.total_count == 5
    assert users.page_count == 3
    assert users.per_page_limit == 2
    assert users.current_page == 2

    refute users |> Pagination.first_page?()
    refute users |> Pagination.last_page?()
    assert users |> Pagination.next_page?()
    assert users |> Pagination.prev_page?()

    user = hd(users.items)
    assert user.user_id == 20_001
  end

  test "finds a team user" do
    response = %{
      team_id: @team_id,
      team_user: %{
        user_id: @user_id,
        email: "user@example.com",
        fullname: "Ilya K",
        created_at: "2018-08-21 15:35:25 (Etc/UTC)",
        created_at_timestamp: 1_534_865_725,
        role: "owner"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/users/#{@user_id}")

      response
      |> ok()
    end)

    {:ok, %TeamUserModel{} = user} = TeamUsers.find(@team_id, @user_id)

    assert user.user_id == @user_id
    assert user.email == "user@example.com"
    assert user.fullname == "Ilya K"
    assert user.created_at == "2018-08-21 15:35:25 (Etc/UTC)"
    assert user.created_at_timestamp == 1_534_865_725
    assert user.role == "owner"
  end

  test "updates a team user" do
    data = %{
      role: "admin"
    }

    response = %{
      team_id: @team_id,
      team_user: %{
        user_id: @user_id,
        role: "admin"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/users/#{@user_id}", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TeamUserModel{} = user} = TeamUsers.update(@team_id, @user_id, data)

    assert user.user_id == @user_id
    assert user.role == "admin"
  end

  test "deletes a team user" do
    response = %{
      team_id: @team_id,
      team_user_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/users/#{@user_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = TeamUsers.delete(@team_id, @user_id)

    assert resp.team_id == @team_id
    assert resp.team_user_deleted
  end
end
