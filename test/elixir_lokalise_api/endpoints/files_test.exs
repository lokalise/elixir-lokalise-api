import ExUnit.CaptureIO

defmodule ElixirLokaliseApi.FilesTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Files
  alias ElixirLokaliseApi.QueuedProcesses
  alias ElixirLokaliseApi.Collection.Files, as: FilesCollection
  alias ElixirLokaliseApi.Model.QueuedProcess, as: ProcessModel

  doctest Files

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all files" do
    files =
      [
        "%LANG_ISO%.yml",
        "file_1.json",
        "file_2.yml",
        "sample.yml",
        "async.json",
        "__unassigned__"
      ]
      |> Enum.with_index()
      |> Enum.map(fn {filename, i} ->
        %{
          filename: filename,
          key_count: (i + 1) * 2
        }
      end)

    files_response = %{
      project_id: @project_id,
      branch: "master",
      files: files
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files")

      files_response
      |> ok([
        {"x-pagination-total-count", "6"},
        {"x-pagination-page-count", "1"},
        {"x-pagination-limit", "100"},
        {"x-pagination-page", "1"}
      ])
    end)

    {:ok, %FilesCollection{} = files} = Files.all(@project_id)

    assert Enum.count(files.items) == 6
    assert files.total_count == 6
    assert files.page_count == 1
    assert files.per_page_limit == 100
    assert files.current_page == 1
    assert files.project_id == @project_id
    assert files.branch == "master"

    file = files.items |> List.first()
    assert file.filename == "%LANG_ISO%.yml"
    assert file.key_count == 2
  end

  test "lists all files with branch" do
    files =
      [
        "%LANG_ISO%.yml",
        "file_1.json"
      ]
      |> Enum.with_index()
      |> Enum.map(fn {filename, i} ->
        %{
          filename: filename,
          key_count: (i + 1) * 2
        }
      end)

    branch_name = "merge-me"

    files_response = %{
      project_id: @project_id,
      branch: branch_name,
      files: files
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}:#{branch_name}/files")

      files_response
      |> ok()
    end)

    {:ok, %FilesCollection{} = files} = Files.all("#{@project_id}:#{branch_name}")

    assert files.project_id == @project_id
    assert files.branch == branch_name

    file = files.items |> hd()
    assert file.filename == "%LANG_ISO%.yml"
    assert file.key_count == 2
  end

  test "lists paginated files" do
    files =
      [
        "%LANG_ISO%.yml",
        "file_1.json"
      ]
      |> Enum.with_index()
      |> Enum.map(fn {filename, i} ->
        %{
          filename: filename,
          key_count: (i + 1) * 2
        }
      end)

    files_response = %{
      project_id: @project_id,
      branch: "master",
      files: files
    }

    params = [page: 2, limit: 3]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files")

      req
      |> assert_get_params(params)

      files_response
      |> ok([
        {"x-pagination-total-count", "6"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "3"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %FilesCollection{} = files} = Files.all(@project_id, params)

    assert Enum.count(files.items) == 2
    assert files.total_count == 6
    assert files.page_count == 2
    assert files.per_page_limit == 3
    assert files.current_page == 2
    assert files.project_id == @project_id

    refute files |> Pagination.first_page?()
    assert files |> Pagination.last_page?()
    refute files |> Pagination.next_page?()
    assert files |> Pagination.prev_page?()

    file = hd(files.items)
    assert file.filename == "%LANG_ISO%.yml"
  end

  test "downloads files" do
    data = %{
      format: "json",
      original_filenames: true
    }

    bundle_response = %{
      project_id: @project_id,
      branch: "master",
      bundle_url: "https://example.com/fake_bundle.zip"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files/download", "POST")

      req |> assert_json_body(data)

      bundle_response
      |> ok()
    end)

    {:ok, %{} = resp} = Files.download(@project_id, data)

    assert String.contains?(resp.bundle_url, "fake_bundle.zip")
    assert resp.project_id == @project_id
  end

  test "downloads files with too big response" do
    data = %{
      format: "json",
      original_filenames: true
    }

    bundle_response = %{
      project_id: @project_id,
      branch: "master",
      bundle_url: "https://example.com/fake_bundle.zip"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files/download", "POST")

      req |> assert_json_body(data)

      bundle_response
      |> ok([
        {"x-response-too-big", "true"}
      ])
    end)

    warning =
      capture_io(:stderr, fn ->
        {:ok, %{} = resp} = Files.download(@project_id, data)
        assert String.contains?(resp.bundle_url, "fake_bundle.zip")
        assert resp.project_id == @project_id
        assert resp._request_too_big
      end)

    assert warning =~ "Your project is too big for sync download"
  end

  test "downloads file (error)" do
    data = %{
      format: "json",
      original_filenames: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files/download", "POST")

      req |> assert_json_body(data)

      500
      |> err(%{
        error: %{
          message: "Fail",
          code: 500
        }
      })
    end)

    {:error, resp} = Files.download(@project_id, data)

    {msg_data, code} = resp
    message = msg_data.error.message

    assert code == 500
    assert message == "Fail"
  end

  test "downloads files asynchronously" do
    process_id = "1efed526-cd7c-6f2e-9db9-360c3c31288f"

    data = %{
      format: "json",
      original_filenames: true
    }

    bundle_response = %{
      process_id: process_id
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files/async-download", "POST")

      req |> assert_json_body(data)

      bundle_response
      |> ok()
    end)

    {:ok, %ProcessModel{} = process} = Files.download_async(@project_id, data)

    assert process.process_id == process_id

    process_response = %{
      process: %{
        process_id: 1,
        type: "async-export",
        status: "finished",
        message: nil,
        created_by: 1001,
        created_at: "2024-01-01 12:00:00 (Europe/Berlin)",
        created_at_timestamp: 1_700_000_000,
        details: %{
          file_size_kb: 1,
          total_number_of_keys: 4,
          download_url: "https://example.com/fake_export.zip"
        }
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/processes/#{process_id}")

      process_response
      |> ok()
    end)

    {:ok, %ProcessModel{} = process} = QueuedProcesses.find(@project_id, process_id)

    assert process.type == "async-export"
    assert process.status == "finished"

    assert String.contains?(
             process.details[:download_url],
             "fake_export.zip"
           )
  end

  test "uploads files" do
    data = %{
      data: "ZnI6DQogIHRlc3Q6IHRyYW5zbGF0aW9u",
      filename: "sample.yml",
      lang_iso: "fr"
    }

    process_response = %{
      process: %{
        process_id: 1,
        type: "file-import",
        status: "queued"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files/upload", "POST")

      req |> assert_json_body(data)

      process_response
      |> ok()
    end)

    {:ok, %ProcessModel{} = process} = Files.upload(@project_id, data)
    assert process.type == "file-import"
    assert process.status == "queued"
  end

  test "deletes a file" do
    file_id = 1_163_613

    response = %{project_id: @project_id, file_deleted: true}

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/files/#{file_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Files.delete(@project_id, file_id)

    assert resp.file_deleted
    assert resp.project_id == @project_id
  end
end
