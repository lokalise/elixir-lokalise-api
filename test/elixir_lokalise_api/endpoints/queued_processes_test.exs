defmodule ElixirLokaliseApi.QueuedProcessesTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.QueuedProcesses
  alias ElixirLokaliseApi.Model.QueuedProcess, as: QueuedProcessModel
  alias ElixirLokaliseApi.Collection.QueuedProcesses, as: QueuedProcessesCollection

  doctest QueuedProcesses

  @project_id "572560965f984614d567a4.18006942"

  test "lists all processes" do
    processes =
      for i <- 1..3 do
        %{
          process_id: "process_#{i}",
          type: "file-import",
          status: "finished",
          message: "",
          created_by: 20_000 + i,
          created_by_email: "user#{i}@example.com",
          created_at: "2021-03-15 18:53:4#{i} (Etc/UTC)",
          created_at_timestamp: 1_615_834_421 + i
        }
      end

    response = %{
      project_id: @project_id,
      processes: processes
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/processes")

      response
      |> ok()
    end)

    {:ok, %QueuedProcessesCollection{} = processes} = QueuedProcesses.all(@project_id)

    assert Enum.count(processes.items) == 3
    assert processes.project_id == @project_id

    process = hd(processes.items)
    assert process.type == "file-import"
  end

  test "lists paginated processes" do
    params = [page: 2, limit: 2]

    processes =
      for i <- 1..2 do
        %{
          process_id: "process_#{i}",
          type: "file-import",
          status: "finished",
          message: "",
          created_by: 20_000 + i,
          created_by_email: "user#{i}@example.com",
          created_at: "2021-03-15 18:53:4#{i} (Etc/UTC)",
          created_at_timestamp: 1_615_834_421 + i
        }
      end

    response = %{
      project_id: @project_id,
      processes: processes
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/processes")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "3"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %QueuedProcessesCollection{} = processes} =
      QueuedProcesses.all(@project_id, params)

    assert Enum.count(processes.items) == 2
    assert processes.project_id == @project_id
    assert processes.total_count == 3
    assert processes.page_count == 2
    assert processes.per_page_limit == 2
    assert processes.current_page == 2

    refute processes |> Pagination.first_page?()
    assert processes |> Pagination.last_page?()
    refute processes |> Pagination.next_page?()
    assert processes |> Pagination.prev_page?()

    process = hd(processes.items)
    assert process.type == "file-import"
  end

  test "finds a process" do
    process_id = "16a32c85c737fb888ac3abc76eafffd5585c15e1"

    response = %{
      project_id: @project_id,
      process: %{
        process_id: process_id,
        type: "file-import",
        status: "finished",
        message: "",
        created_by: 20_181,
        created_by_email: "user@example.com",
        created_at: "2021-03-15 18:53:41 (Etc/UTC)",
        created_at_timestamp: 1_615_834_421,
        details: %{
          files: [
            %{
              status: "finished",
              message: "",
              name_original: "fr.yml",
              name_custom: "%LANG_ISO%.yml",
              word_count_total: 282,
              key_count_total: 58,
              key_count_inserted: 58,
              key_count_updated: 0,
              key_count_skipped: 0
            }
          ]
        }
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/processes/#{process_id}")

      response
      |> ok()
    end)

    {:ok, %QueuedProcessModel{} = process} = QueuedProcesses.find(@project_id, process_id)

    assert process.type == "file-import"
    assert process.process_id == process_id
    assert process.status == "finished"
    assert process.message == ""
    assert process.created_by == 20_181
    assert process.created_by_email == "user@example.com"
    assert process.created_at == "2021-03-15 18:53:41 (Etc/UTC)"
    assert process.created_at_timestamp == 1_615_834_421

    file_info = process.details.files |> hd
    assert file_info.status == "finished"
  end
end
