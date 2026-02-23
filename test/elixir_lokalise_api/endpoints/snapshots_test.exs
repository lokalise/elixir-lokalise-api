defmodule ElixirLokaliseApi.SnapshotsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Snapshots
  alias ElixirLokaliseApi.Collection.Snapshots, as: SnapshotsCollection
  alias ElixirLokaliseApi.Model.Snapshot, as: SnapshotModel
  alias ElixirLokaliseApi.Model.Project, as: ProjectModel

  doctest Snapshots

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all snapshots" do
    gen_snapshots =
      for i <- 1..2 do
        %{
          snapshot_id: 20_000 + i,
          title: "Fake snapshot #{i}",
          created_by: 1000 + i,
          created_by_email: "user#{i}@example.com",
          created_at: "2020-01-01 00:00:0#{i} (Etc/UTC)",
          created_at_timestamp: 1_600_000_000 + i
        }
      end

    response = %{
      project_id: @project_id,
      snapshots: gen_snapshots
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/snapshots")

      response
      |> ok()
    end)

    {:ok, %SnapshotsCollection{} = snapshots} = Snapshots.all(@project_id)

    assert Enum.count(snapshots.items) == 2
    assert snapshots.project_id == @project_id

    snapshot = hd(snapshots.items)
    assert snapshot.snapshot_id == 20_001
    assert snapshot.title == "Fake snapshot 1"
    assert snapshot.created_at == "2020-01-01 00:00:01 (Etc/UTC)"
    assert snapshot.created_at_timestamp == 1_600_000_001
    assert snapshot.created_by == 1001
    assert snapshot.created_by_email == "user1@example.com"
  end

  test "lists paginated snapshots" do
    gen_snapshots =
      for i <- 1..2 do
        %{
          snapshot_id: 20_000 + i,
          title: "Fake snapshot #{i}",
          created_by: 1000 + i,
          created_by_email: "user#{i}@example.com",
          created_at: "2020-01-01 00:00:0#{i} (Etc/UTC)",
          created_at_timestamp: 1_600_000_000 + i
        }
      end

    response = %{
      project_id: @project_id,
      snapshots: gen_snapshots
    }

    params = [page: 2, limit: 1]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/snapshots")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "4"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %SnapshotsCollection{} = snapshots} = Snapshots.all(@project_id, params)

    assert Enum.count(snapshots.items) == 2
    assert snapshots.project_id == @project_id
    assert snapshots.total_count == 4
    assert snapshots.page_count == 2
    assert snapshots.per_page_limit == 2
    assert snapshots.current_page == 2

    refute snapshots |> Pagination.first_page?()
    assert snapshots |> Pagination.last_page?()
    refute snapshots |> Pagination.next_page?()
    assert snapshots |> Pagination.prev_page?()

    snapshot = hd(snapshots.items)
    assert snapshot.snapshot_id == 20_001
  end

  test "create a snapshot" do
    data = %{
      title: "Elixir snap"
    }

    response = %{
      project_id: @project_id,
      snapshot: %{
        snapshot_id: 516_515,
        title: "Elixir snap",
        created_by: 20181,
        created_by_email: "user@example.com",
        created_at: "2021-03-17 14:15:00 (Etc/UTC)",
        created_at_timestamp: 1_615_990_500
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/snapshots", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %SnapshotModel{} = snapshot} = Snapshots.create(@project_id, data)

    assert snapshot.title == "Elixir snap"
  end

  test "restore a snapshot" do
    snapshot_id = 243_330

    response = %{
      project_id: "6608164760521052b87f59.32218804",
      project_type: "localization_files",
      name: "Demo Phoenix copy",
      description: "Description Phoenix",
      created_at: "2021-03-17 14:21:06 (Etc/UTC)",
      created_at_timestamp: 1_615_990_866,
      created_by: 20181,
      created_by_email: "user@example.com",
      team_id: 176_692,
      base_language_id: 640,
      base_language_iso: "en"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/snapshots/#{snapshot_id}", "POST")

      req |> assert_json_body("")

      response
      |> ok()
    end)

    {:ok, %ProjectModel{} = project} = Snapshots.restore(@project_id, snapshot_id)

    refute project.project_id == @project_id
    assert project.name == "Demo Phoenix copy"
  end

  test "delete a snapshot" do
    snapshot_id = 516_515

    response = %{
      project_id: @project_id,
      snapshot_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/snapshots/#{snapshot_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Snapshots.delete(@project_id, snapshot_id)

    assert resp.project_id == @project_id
    assert resp.snapshot_deleted
  end
end
