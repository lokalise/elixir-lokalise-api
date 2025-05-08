defmodule ElixirLokaliseApi.ContributorsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Contributors
  alias ElixirLokaliseApi.Model.Contributor, as: ContributorModel
  alias ElixirLokaliseApi.Collection.Contributors, as: ContributorsCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Contributors

  @project_id "217830385f9c0fdbd589f0.91420183"

  test "lists all contributors" do
    use_cassette "contributors_all" do
      {:ok, %ContributorsCollection{} = contributors} = Contributors.all(@project_id)

      assert Enum.count(contributors.items) == 3
      assert contributors.project_id == @project_id

      contributor = hd(contributors.items)
      assert contributor.user_id == 20181
    end
  end

  test "lists paginated contributors" do
    use_cassette "contributors_all_paginated" do
      {:ok, %ContributorsCollection{} = contributors} =
        Contributors.all(@project_id, page: 2, limit: 1)

      assert Enum.count(contributors.items) == 1
      assert contributors.project_id == @project_id
      assert contributors.total_count == 3
      assert contributors.page_count == 3
      assert contributors.per_page_limit == 1
      assert contributors.current_page == 2

      refute contributors |> Pagination.first_page?()
      refute contributors |> Pagination.last_page?()
      assert contributors |> Pagination.next_page?()
      assert contributors |> Pagination.prev_page?()

      contributor = contributors.items |> List.first()
      assert contributor.user_id == 25261
    end
  end

  test "finds a contributor" do
    use_cassette "contributors_find" do
      {:ok, %ContributorModel{} = contributor} = Contributors.find(@project_id, 72008)

      assert contributor.user_id == 72008
      assert contributor.email == "golosizpru+ann@gmail.com"
      assert contributor.fullname == "Ann"
      assert contributor.created_at == "2020-07-27 14:35:45 (Etc/UTC)"
      assert contributor.created_at_timestamp == 1_595_860_545
      refute contributor.is_admin
      assert contributor.is_reviewer
      refute List.first(contributor.languages).is_writable
      assert contributor.admin_rights == []
      assert contributor.role_id == 5
    end
  end

  test "finds a me (current contributor)" do
    use_cassette "contributors_me" do
      {:ok, %ContributorModel{} = contributor} =
        Contributors.me("5868381966b39e5053ff15.63486389")

      assert contributor.fullname == "Ilya B"
    end
  end

  test "creates a contributor" do
    use_cassette "contributors_create" do
      data = %{
        contributors: [
          %{
            email: "elixir_test@example.com",
            fullname: "Elixir Rocks",
            languages: [
              %{
                lang_iso: "en",
                is_writable: false
              }
            ]
          }
        ]
      }

      {:ok, %ContributorsCollection{} = contributors} = Contributors.create(@project_id, data)

      assert contributors.project_id == @project_id

      contributor = hd(contributors.items)

      assert contributor.email == "elixir_test@example.com"
      assert contributor.fullname == "Elixir Rocks"
      assert List.first(contributor.languages).lang_iso == "en"
    end
  end

  test "updates a contributor" do
    use_cassette "contributors_update" do
      data = %{
        is_reviewer: true
      }

      {:ok, %ContributorModel{} = contributor} = Contributors.update(@project_id, 97280, data)

      assert contributor.user_id == 97280
      assert contributor.is_reviewer
    end
  end

  test "deletes a contributor" do
    use_cassette "contributors_delete" do
      {:ok, %{} = resp} = Contributors.delete(@project_id, 97280)

      assert resp.contributor_deleted
      assert resp.project_id == @project_id
    end
  end
end
