defmodule ElixirLokaliseApi.TeamsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Teams
  alias ElixirLokaliseApi.Collection.Teams, as: TeamsCollection

  setup_all do
    HTTPoison.start
  end

  doctest Teams

  test "lists all teams" do
    use_cassette "teams_all" do
      {:ok, %TeamsCollection{} = teams} = Teams.all

      assert Enum.count(teams.items) == 5

      team = hd teams.items
      assert team.team_id == 218347
      assert team.name == "Webinar"
      assert team.created_at == "2020-09-08 14:03:19 (Etc/UTC)"
      assert team.created_at_timestamp == 1599573799
      assert team.plan == "Trial"
      assert team.quota_usage.keys == 101
      assert team.quota_allowed.mau == 999999999
    end
  end

  test "lists paginated teams" do
    use_cassette "teams_all_paginated" do
      {:ok, %TeamsCollection{} = teams} = Teams.all page: 2, limit: 3

      team = hd teams.items
      assert team.team_id == 176692

      assert Enum.count(teams.items) == 2
      assert teams.total_count == 5
      assert teams.page_count == 2
      assert teams.per_page_limit == 3
      assert teams.current_page == 2

      refute teams |> Pagination.first_page?
      assert teams |> Pagination.last_page?
      refute teams |> Pagination.next_page?
      assert teams |> Pagination.prev_page?
    end
  end
end
