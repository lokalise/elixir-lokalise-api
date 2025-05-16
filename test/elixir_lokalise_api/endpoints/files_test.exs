import ExUnit.CaptureIO

defmodule ElixirLokaliseApi.FilesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Files
  alias ElixirLokaliseApi.QueuedProcesses
  alias ElixirLokaliseApi.Collection.Files, as: FilesCollection
  alias ElixirLokaliseApi.Model.QueuedProcess, as: ProcessModel

  setup_all do
    HTTPoison.start()
  end

  doctest Files

  @project_id "803826145ba90b42d5d860.46800099"
  @file_id 1_163_613

  test "lists all files" do
    use_cassette "files_all" do
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
      assert file.key_count == 66
    end
  end

  test "lists all files with branch" do
    use_cassette "files_all_branch" do
      {:ok, %FilesCollection{} = files} = Files.all("#{@project_id}:merge-me")

      assert files.project_id == @project_id
      assert files.branch == "merge-me"

      file = files.items |> List.first()
      assert file.filename == "%LANG_ISO%.yml"
      assert file.key_count == 3
    end
  end

  test "lists paginated files" do
    use_cassette "files_all_paginated" do
      {:ok, %FilesCollection{} = files} = Files.all(@project_id, page: 2, limit: 3)

      assert Enum.count(files.items) == 2
      assert files.total_count == 5
      assert files.page_count == 2
      assert files.per_page_limit == 3
      assert files.current_page == 2
      assert files.project_id == @project_id

      refute files |> Pagination.first_page?()
      assert files |> Pagination.last_page?()
      refute files |> Pagination.next_page?()
      assert files |> Pagination.prev_page?()

      file = hd(files.items)
      assert file.filename == "test_async.json"
    end
  end

  test "downloads files" do
    use_cassette "files_download" do
      data = %{
        format: "json",
        original_filenames: true
      }

      {:ok, %{} = resp} = Files.download(@project_id, data)

      assert String.contains?(resp.bundle_url, "Demo_Phoenix")
      assert resp.project_id == @project_id
    end
  end

  test "downloads files with too big response" do
    use_cassette "files_download_response_too_big" do
      data = %{
        format: "json",
        original_filenames: true
      }

      warning =
        capture_io(:stderr, fn ->
          {:ok, %{} = resp} = Files.download(@project_id, data)
          assert String.contains?(resp.bundle_url, "Demo_Phoenix")
          assert resp.project_id == @project_id
          assert resp._request_too_big
        end)

      assert warning =~ "Your project is too big for sync download"
    end
  end

  test "downloads file (error)" do
    use_cassette "files_download_error" do
      data = %{
        format: "json",
        original_filenames: true
      }

      {:error, resp} = Files.download(@project_id, data)

      {msg_data, code} = resp
      message = msg_data.error.message

      assert code == 500
      assert message == "Fail"
    end
  end

  test "downloads files asynchronously" do
    process_id = "1efed526-cd7c-6f2e-9db9-360c3c31288f"
    project_id = "6504960967ab53d45e0ed7.15877499"

    use_cassette "files_download_async" do
      data = %{
        format: "json",
        original_filenames: true
      }

      {:ok, %ProcessModel{} = process} = Files.download_async(project_id, data)

      assert process.process_id == process_id
    end

    use_cassette "files_download_check" do
      {:ok, %ProcessModel{} = process} = QueuedProcesses.find(project_id, process_id)

      assert process.type == "async-export"
      assert process.status == "finished"

      assert String.contains?(
               process.details[:download_url],
               "lokalise-live-lok-s3-fss-export.s3.eu-central"
             )
    end
  end

  test "uploads files" do
    use_cassette "files_upload" do
      data = %{
        data: "ZnI6DQogIHRlc3Q6IHRyYW5zbGF0aW9u",
        filename: "sample.yml",
        lang_iso: "ru"
      }

      {:ok, %ProcessModel{} = process} = Files.upload(@project_id, data)
      assert process.type == "file-import"
      assert process.status == "queued"
    end

    use_cassette "files_upload_check" do
      process_id = "edcdae47fd37b45778aaceee41e5f3b75b1d8964"
      {:ok, %ProcessModel{} = process} = QueuedProcesses.find(@project_id, process_id)
      assert process.type == "file-import"
      assert process.status == "finished"
    end
  end

  test "deletes a file" do
    use_cassette "file_delete" do
      docs_project_id = "507504186242fccb32f015.15252556"
      {:ok, %{} = resp} = Files.delete(docs_project_id, @file_id)

      assert resp.file_deleted
      assert resp.project_id == docs_project_id
    end
  end
end
