defmodule ElixirLokaliseApi.BranchesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Branches
  alias ElixirLokaliseApi.Model.Branch, as: BranchModel
  alias ElixirLokaliseApi.Collection.Branches, as: BranchesCollection

  setup_all do
    HTTPoison.start
  end

  doctest Branches

  test "lists all branches" do
    use_cassette "branches_all" do
      project_id = "771432525f9836bbd50459.22958598"
      {:ok, %BranchesCollection{} = branches} = Branches.all project_id

      assert Enum.count(branches.items) == 3
      assert branches.total_count == 2
      assert branches.page_count == 1
      assert branches.per_page_limit == 100
      assert branches.current_page == 1
      assert branches.project_id == project_id

      branch = branches.items |> List.first()
      assert branch.name == "develop"
    end
  end

  test "lists paginated branches" do
    use_cassette "branches_all_paginated" do
      project_id = "771432525f9836bbd50459.22958598"
      {:ok, %BranchesCollection{} = branches} = Branches.all project_id, page: 2, limit: 1

      assert branches.total_count == 2
      assert branches.page_count == 2
      assert branches.per_page_limit == 1
      assert branches.current_page == 2

      refute branches |> Pagination.first_page?
      assert branches |> Pagination.last_page?
      refute branches |> Pagination.next_page?
      assert branches |> Pagination.prev_page?

      branch = branches.items |> List.first()
      assert branch.name == "master"
    end
  end

  test "finds a branch" do
    use_cassette "branch_find" do
      project_id = "771432525f9836bbd50459.22958598"
      branch_id = 110704

      {:ok, %BranchModel{} = branch} = Branches.find project_id, branch_id

      assert branch.branch_id == branch_id
      assert branch.name == "develop"
      assert branch.created_at == "2021-03-06 17:03:20 (Etc/UTC)"
      assert branch.created_at_timestamp == 1615050200
      assert branch.created_by == 20181
      assert branch.created_by_email == "bodrovis@protonmail.com"
    end
  end

  test "creates a branch" do
    use_cassette "branch_create" do
      project_id = "771432525f9836bbd50459.22958598"
      data = %{name: "Elixir"}

      {:ok, %BranchModel{} = branch} = Branches.create project_id, data

      assert branch.name == "Elixir"
    end
  end

  test "updates a branch" do
    use_cassette "branch_update" do
      project_id = "771432525f9836bbd50459.22958598"
      branch_id = 110712
      data = %{name: "Elixir-update"}

      {:ok, %BranchModel{} = branch} = Branches.update project_id, branch_id, data

      assert branch.name == "Elixir-update"
      assert branch.branch_id == branch_id
    end
  end

  test "merges a branch with master" do
    use_cassette "branch_merge_default" do
      project_id = "771432525f9836bbd50459.22958598"
      branch_id = 110712

      {:ok, %{} = resp} = Branches.merge project_id, branch_id

      assert resp.branch_merged

      assert resp.branch.name == "Elixir-update"
      assert resp.target_branch.name == "master"
    end
  end

  test "merges a branch with target" do
    use_cassette "branch_merge_target" do
      project_id = "771432525f9836bbd50459.22958598"
      branch_id = 86328
      target_branch_id = 110704
      data = %{force_conflict_resolve_using: "target", target_branch_id: target_branch_id}

      {:ok, %{} = resp} = Branches.merge project_id, branch_id, data

      assert resp.branch_merged

      assert resp.branch.name == "master"
      assert resp.target_branch.name == "develop"
    end
  end

  test "deletes a branch" do
    use_cassette "branch_delete" do
      project_id = "771432525f9836bbd50459.22958598"
      branch_id = 86328

      {:ok, %{} = resp} = Branches.delete project_id, branch_id

      assert resp.branch_deleted
      assert resp.project_id == project_id
    end
  end
end
