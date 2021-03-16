defmodule ElixirLokaliseApi.ScreenshotsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Screenshots
  alias ElixirLokaliseApi.Model.Screenshot, as: ScreenshotModel
  alias ElixirLokaliseApi.Collection.Screenshots, as: ScreenshotsCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Screenshots

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all screenshots" do
    use_cassette "screenshots_all" do
      {:ok, %ScreenshotsCollection{} = screenshots} = Screenshots.all(@project_id)

      assert Enum.count(screenshots.items) == 3
      assert screenshots.project_id == @project_id

      screenshot = hd(screenshots.items)
      assert screenshot.screenshot_id == 189_266
    end
  end

  test "lists paginated screenshots" do
    use_cassette "screenshots_all_paginated" do
      {:ok, %ScreenshotsCollection{} = screenshots} =
        Screenshots.all(@project_id, page: 2, limit: 1)

      assert Enum.count(screenshots.items) == 1
      assert screenshots.project_id == @project_id

      assert screenshots.project_id == @project_id
      assert screenshots.total_count == 3
      assert screenshots.page_count == 3
      assert screenshots.per_page_limit == 1
      assert screenshots.current_page == 2

      refute screenshots |> Pagination.first_page?()
      refute screenshots |> Pagination.last_page?()
      assert screenshots |> Pagination.next_page?()
      assert screenshots |> Pagination.prev_page?()

      screenshot = hd(screenshots.items)
      assert screenshot.screenshot_id == 757_672
    end
  end

  test "finds a screenshot" do
    use_cassette "screenshot_find" do
      screenshot_id = 757_672
      {:ok, %ScreenshotModel{} = screenshot} = Screenshots.find(@project_id, screenshot_id)

      assert screenshot.screenshot_id == screenshot_id
      assert screenshot.key_ids == []
      assert String.starts_with?(screenshot.url, "https://s3-eu-west-1")
      assert screenshot.title == "1"
      assert screenshot.description == ""
      assert screenshot.screenshot_tags == []
      assert screenshot.width == 307
      assert screenshot.height == 97
      assert screenshot.created_at == "2021-03-16 17:55:00 (Etc/UTC)"
      assert screenshot.created_at_timestamp == 1_615_917_300
    end
  end

  test "creates screenshots" do
    use_cassette "screenshot_create" do
      {:ok, base64} =
        Path.expand("test/fixtures/screenshot_base64.txt")
        |> File.read()

      data = %{
        screenshots: [
          %{
            data: base64,
            title: "Elixir screen"
          }
        ]
      }

      {:ok, %ScreenshotsCollection{} = screenshots} = Screenshots.create(@project_id, data)
      assert screenshots.project_id == @project_id
      assert screenshots.errors == []

      screenshot = hd(screenshots.items)

      assert screenshot.title == "Elixir screen"
    end
  end

  test "updates a screenshot" do
    use_cassette "screenshot_update" do
      screenshot_id = 757_683

      data = %{
        title: "Elixir updated",
        description: "Mix test"
      }

      {:ok, %ScreenshotModel{} = screenshot} =
        Screenshots.update(@project_id, screenshot_id, data)

      assert screenshot.title == "Elixir updated"
      assert screenshot.screenshot_id == screenshot_id
      assert screenshot.description == "Mix test"
    end
  end

  test "deletes a screenshot" do
    use_cassette "screenshot_delete" do
      screenshot_id = 757_683
      {:ok, %{} = resp} = Screenshots.delete(@project_id, screenshot_id)

      assert resp.project_id == @project_id
      assert resp.screenshot_deleted
    end
  end
end
