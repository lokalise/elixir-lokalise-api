defmodule ElixirLokaliseApi.SnapshotsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Snapshots
  alias ElixirLokaliseApi.Collection.Snapshots, as: SnapshotsCollection
  alias ElixirLokaliseApi.Model.Snapshot, as: SnapshotModel
  alias ElixirLokaliseApi.Model.Project, as: ProjectModel

  setup_all do
    HTTPoison.start()
  end

  doctest Snapshots

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all snapshots" do
    use_cassette "snapshots_all" do
      {:ok, %SnapshotsCollection{} = snapshots} = Snapshots.all(@project_id)

      assert Enum.count(snapshots.items) == 2
      assert snapshots.project_id == @project_id

      snapshot = hd(snapshots.items)
      assert snapshot.snapshot_id == 27882
      assert snapshot.title == "test rspec"
      assert snapshot.created_at == "2018-12-10 17:02:04 (Etc/UTC)"
      assert snapshot.created_at_timestamp == 1544461324
      assert snapshot.created_by == 20181
      assert snapshot.created_by_email == "bodrovis@protonmail.com"
    end
  end

  test "lists paginated snapshots" do
    use_cassette "snapshots_all_paginated" do
      {:ok, %SnapshotsCollection{} = snapshots} = Snapshots.all(@project_id, page: 2, limit: 1)

      assert Enum.count(snapshots.items) == 1
      assert snapshots.project_id == @project_id
      assert snapshots.total_count == 2
      assert snapshots.page_count == 2
      assert snapshots.per_page_limit == 1
      assert snapshots.current_page == 2

      refute snapshots |> Pagination.first_page?()
      assert snapshots |> Pagination.last_page?()
      refute snapshots |> Pagination.next_page?()
      assert snapshots |> Pagination.prev_page?()

      snapshot = hd(snapshots.items)
      assert snapshot.snapshot_id == 243330
    end
  end

  test "create a snapshot" do
    use_cassette "snapshot_create" do
      data = %{
        title: "Elixir snap"
      }
      {:ok, %SnapshotModel{} = snapshot} = Snapshots.create(@project_id, data)

      assert snapshot.title == "Elixir snap"
    end
  end

  test "restore a snapshot" do
    use_cassette "snapshot_restore" do
      {:ok, %ProjectModel{} = project} = Snapshots.restore(@project_id, 243330)

      refute project.project_id == @project_id
      assert project.name == "Demo Phoenix copy"
    end
  end

  test "delete a snapshot" do
    use_cassette "snapshot_delete" do
      {:ok, %{} = resp} = Snapshots.delete(@project_id, 516515)

      assert resp.project_id == @project_id
      assert resp.snapshot_deleted
    end
  end
end
