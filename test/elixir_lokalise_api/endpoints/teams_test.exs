defmodule ElixirLokaliseApi.TeamsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Teams
  alias ElixirLokaliseApi.Collection.Teams, as: TeamsCollection
  alias ElixirLokaliseApi.Model.Team, as: TeamModel

  doctest Teams

  test "lists all teams" do
    response = %{
      teams: [
        %{
          team_id: 176_692,
          name: "Ilya's Team",
          plan: "Trial",
          created_at: "2018-08-21 15:35:25 (Etc/UTC)",
          created_at_timestamp: 1_534_865_725,
          quota_usage: %{
            users: 20,
            keys: 183,
            projects: 21,
            mau: 0
          },
          quota_allowed: %{
            users: 999_999_999,
            keys: 999_999_999,
            projects: 999_999_999,
            mau: 999_999_999
          }
        },
        %{
          team_id: 170_312,
          name: "Lokalise",
          plan: "Trial",
          created_at: "2017-10-17 09:10:00 (Etc/UTC)",
          created_at_timestamp: 1_508_231_400,
          quota_usage: %{
            users: 55,
            keys: 6_958,
            projects: 23,
            mau: 0
          },
          quota_allowed: %{
            users: 999_999_999,
            keys: 999_999_999,
            projects: 999_999_999,
            mau: 999_999_999
          }
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams")

      response
      |> ok()
    end)

    {:ok, %TeamsCollection{} = teams} = Teams.all()

    assert Enum.count(teams.items) == 2

    team = hd(teams.items)
    assert team.team_id == 176_692
    assert team.name == "Ilya's Team"
    assert team.created_at == "2018-08-21 15:35:25 (Etc/UTC)"
    assert team.created_at_timestamp == 1_534_865_725
    assert team.plan == "Trial"
    assert team.quota_usage.keys == 183
    assert team.quota_allowed.mau == 999_999_999
  end

  test "lists paginated teams" do
    response = %{
      teams: [
        %{
          team_id: 176_692,
          name: "Ilya's Team",
          plan: "Trial"
        },
        %{
          team_id: 170_312,
          name: "Lokalise",
          plan: "Trial"
        }
      ]
    }

    params = [page: 2, limit: 3]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "5"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "3"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %TeamsCollection{} = teams} = Teams.all(params)

    team = hd(teams.items)
    assert team.team_id == 176_692

    assert Enum.count(teams.items) == 2
    assert teams.total_count == 5
    assert teams.page_count == 2
    assert teams.per_page_limit == 3
    assert teams.current_page == 2

    refute teams |> Pagination.first_page?()
    assert teams |> Pagination.last_page?()
    refute teams |> Pagination.next_page?()
    assert teams |> Pagination.prev_page?()
  end

  test "finds team" do
    response = %{
      team: %{
        team_id: 176_692,
        name: "Ilya's Team",
        plan_name: "Trial",
        created_at: "2018-08-21T17:35:25+02:00",
        created_at_timestamp: 1_534_865_725,
        quota_usage: %{
          id: nil,
          users: 20,
          keys: 103,
          projects: 11,
          mau: 0,
          trafficBytes: 817,
          aiWords: 678
        },
        quota_allowed: %{
          id: nil,
          users: 999_999_999,
          keys: 999_999_999,
          projects: 999_999_999,
          mau: 0,
          trafficBytes: 1,
          aiWords: 100_200
        },
        is_team_suspended: false,
        is_end_of_trial_active: false,
        trial_days_left: 64
      }
    }

    team_id = 176_692

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{team_id}")

      response
      |> ok()
    end)

    {:ok, %TeamModel{} = team} = Teams.find(team_id)

    assert team.team_id == team_id
    assert team.name == "Ilya's Team"
  end
end
