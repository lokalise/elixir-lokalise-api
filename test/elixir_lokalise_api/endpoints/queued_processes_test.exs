defmodule ElixirLokaliseApi.QueuedProcessesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.QueuedProcesses
  alias ElixirLokaliseApi.Model.QueuedProcess, as: QueuedProcessModel
  alias ElixirLokaliseApi.Collection.QueuedProcesses, as: QueuedProcessesCollection

  setup_all do
    HTTPoison.start()
  end

  doctest QueuedProcesses

  @project_id "572560965f984614d567a4.18006942"

  test "lists all processes" do
    use_cassette "processes_all" do
      {:ok, %QueuedProcessesCollection{} = processes} = QueuedProcesses.all(@project_id)

      assert Enum.count(processes.items) == 3
      assert processes.project_id == @project_id

      process = hd processes.items
      assert process.type == "file-import"
    end
  end

  test "lists paginated processes" do
    use_cassette "processes_all_paginated" do
      {:ok, %QueuedProcessesCollection{} = processes} = QueuedProcesses.all(@project_id, page: 2, limit: 1)

      assert Enum.count(processes.items) == 1
      assert processes.project_id == @project_id
      assert processes.total_count == 3
      assert processes.page_count == 3
      assert processes.per_page_limit == 1
      assert processes.current_page == 2

      refute processes |> Pagination.first_page?()
      refute processes |> Pagination.last_page?()
      assert processes |> Pagination.next_page?()
      assert processes |> Pagination.prev_page?()

      process = hd processes.items
      assert process.type == "file-import"
    end
  end

  test "finds a process" do
    use_cassette "process_find" do
      process_id = "16a32c85c737fb888ac3abc76eafffd5585c15e1"
      {:ok, %QueuedProcessModel{} = process} = QueuedProcesses.find(@project_id, process_id)

      assert process.type == "file-import"
      assert process.process_id == process_id
      assert process.status == "finished"
      assert process.message == ""
      assert process.created_by == 20181
      assert process.created_by_email == "bodrovis@protonmail.com"
      assert process.created_at == "2021-03-15 18:53:41 (Etc/UTC)"
      assert process.created_at_timestamp == 1615834421
    end
  end
end
