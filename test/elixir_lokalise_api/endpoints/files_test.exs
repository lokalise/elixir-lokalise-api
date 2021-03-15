defmodule ElixirLokaliseApi.FilesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Files
  alias ElixirLokaliseApi.Collection.Files, as: FilesCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Files

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all files" do
    use_cassette "files_all" do
      {:ok, %FilesCollection{} = files} = Files.all(@project_id)

      assert Enum.count(files.items) == 5
      assert files.total_count == 5
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

      file = files.items |> List.first()
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
end
