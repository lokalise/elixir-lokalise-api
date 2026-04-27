defmodule ElixirLokaliseApi.BranchesTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Branches
  alias ElixirLokaliseApi.Collection.Branches, as: BranchesCollection
  alias ElixirLokaliseApi.Model.Branch, as: BranchModel
  alias ElixirLokaliseApi.Pagination

  doctest Branches

  test "lists all branches" do
    project_id = "771432525f9836bbd50459.22958598"

    branches_gen =
      for i <- 1..3 do
        %{
          branch_id: 100_000 + i,
          name: "branch_#{i}",
          created_at: "2024-01-01 00:00:00 (Etc/UTC)",
          created_at_timestamp: 1_700_000_000 + i,
          created_by: 1_000 + i,
          created_by_email: "user#{i}@example.com"
        }
      end

    branches_resp = %{
      project_id: project_id,
      branch: "master",
      branches: branches_gen
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/branches")

      branches_resp
      |> ok([
        {"x-pagination-total-count", "3"},
        {"x-pagination-page-count", "1"},
        {"x-pagination-limit", "100"},
        {"x-pagination-page", "1"}
      ])
    end)

    {:ok, %BranchesCollection{} = branches} = Branches.all(project_id)

    assert Enum.count(branches.items) == 3
    assert branches.total_count == 3
    assert branches.page_count == 1
    assert branches.per_page_limit == 100
    assert branches.current_page == 1
    assert branches.project_id == project_id

    branch = branches.items |> List.first()
    assert branch.name == "branch_1"
  end

  test "lists paginated branches" do
    project_id = "771432525f9836bbd50459.22958598"

    branches_resp = %{
      project_id: project_id,
      branch: "master",
      branches: [
        %{
          branch_id: 100_000,
          name: "branch_1",
          created_at: "2024-01-01 00:00:00 (Etc/UTC)",
          created_at_timestamp: 1_700_000_000,
          created_by: 1_000,
          created_by_email: "user#{1}@example.com"
        }
      ]
    }

    params = [
      page: 2,
      limit: 1
    ]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/branches")

      req
      |> assert_get_params(params)

      branches_resp
      |> ok([
        {"x-pagination-total-count", "2"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "1"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %BranchesCollection{} = branches} = Branches.all(project_id, params)

    assert branches.total_count == 2
    assert branches.page_count == 2
    assert branches.per_page_limit == 1
    assert branches.current_page == 2

    refute branches |> Pagination.first_page?()
    assert branches |> Pagination.last_page?()
    refute branches |> Pagination.next_page?()
    assert branches |> Pagination.prev_page?()

    branch = hd(branches.items)
    assert branch.name == "branch_1"
  end

  test "finds a branch" do
    project_id = "771432525f9836bbd50459.22958598"
    branch_id = 110_704

    branch_resp = %{
      project_id: project_id,
      branch: %{
        branch_id: branch_id,
        name: "branch_1",
        created_at: "2024-01-01 00:00:00 (Etc/UTC)",
        created_at_timestamp: 1_700_000_000,
        created_by: 1_000,
        created_by_email: "user1@example.com"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/branches/#{branch_id}")

      branch_resp
      |> ok()
    end)

    {:ok, %BranchModel{} = branch} = Branches.find(project_id, branch_id)

    assert branch.branch_id == branch_id
    assert branch.name == "branch_1"
    assert branch.created_at == "2024-01-01 00:00:00 (Etc/UTC)"
    assert branch.created_at_timestamp == 1_700_000_000
    assert branch.created_by == 1_000
    assert branch.created_by_email == "user1@example.com"
  end

  test "creates a branch" do
    project_id = "771432525f9836bbd50459.22958598"
    data = %{name: "Elixir"}

    branch_resp = %{
      project_id: project_id,
      branch: %{
        branch_id: 123,
        name: data.name,
        created_at: "2024-01-01 00:00:00 (Etc/UTC)",
        created_at_timestamp: 1_700_000_000
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/branches", "POST")

      req |> assert_json_body(data)

      branch_resp |> ok()
    end)

    {:ok, %BranchModel{} = branch} = Branches.create(project_id, data)

    assert branch.name == "Elixir"
  end

  test "updates a branch" do
    project_id = "771432525f9836bbd50459.22958598"
    branch_id = 110_712
    data = %{name: "Elixir-update"}

    branch_resp = %{
      project_id: project_id,
      branch: %{
        branch_id: branch_id,
        name: data.name,
        created_at: "2024-01-01 00:00:00 (Etc/UTC)",
        created_at_timestamp: 1_700_000_000
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/branches/#{branch_id}", "PUT")

      req |> assert_json_body(data)

      branch_resp |> ok()
    end)

    {:ok, %BranchModel{} = branch} = Branches.update(project_id, branch_id, data)

    assert branch.name == "Elixir-update"
    assert branch.branch_id == branch_id
  end

  test "merges a branch with master" do
    project_id = "771432525f9836bbd50459.22958598"
    branch_id = 110_712

    merge_resp = %{
      project_id: project_id,
      branch_merged: true,
      branch: %{
        branch_id: branch_id,
        name: "Elixir-update"
      },
      target_branch: %{
        branch_id: 2,
        name: "master"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/branches/#{branch_id}/merge", "POST")

      merge_resp |> ok()
    end)

    {:ok, %{} = resp} = Branches.merge(project_id, branch_id)

    assert resp.branch_merged

    assert resp.branch.name == "Elixir-update"
    assert resp.target_branch.name == "master"
  end

  test "merges a branch with target" do
    project_id = "771432525f9836bbd50459.22958598"
    branch_id = 86_328
    target_branch_id = 110_704

    merge_resp = %{
      project_id: project_id,
      branch_merged: true,
      branch: %{
        branch_id: branch_id,
        name: "master"
      },
      target_branch: %{
        branch_id: target_branch_id,
        name: "develop"
      }
    }

    data = %{force_conflict_resolve_using: "target", target_branch_id: target_branch_id}

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/branches/#{branch_id}/merge", "POST")

      req |> assert_json_body(data)

      merge_resp |> ok()
    end)

    {:ok, %{} = resp} = Branches.merge(project_id, branch_id, data)

    assert resp.branch_merged

    assert resp.branch.name == "master"
    assert resp.target_branch.name == "develop"
  end

  test "deletes a branch" do
    project_id = "771432525f9836bbd50459.22958598"
    branch_id = 86_328

    delete_resp = %{
      project_id: project_id,
      branch: "master",
      branch_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req |> assert_path_method("/api2/projects/#{project_id}/branches/#{branch_id}", "DELETE")

      delete_resp |> ok()
    end)

    {:ok, %{} = resp} = Branches.delete(project_id, branch_id)

    assert resp.branch_deleted
    assert resp.project_id == project_id
  end
end
