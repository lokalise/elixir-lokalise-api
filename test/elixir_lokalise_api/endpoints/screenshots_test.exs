defmodule ElixirLokaliseApi.ScreenshotsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.Screenshots, as: ScreenshotsCollection
  alias ElixirLokaliseApi.Model.Screenshot, as: ScreenshotModel
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Screenshots

  doctest Screenshots

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all screenshots" do
    response = %{
      project_id: @project_id,
      screenshots: screenshots()
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/screenshots")

      response
      |> ok()
    end)

    {:ok, %ScreenshotsCollection{} = screenshots} = Screenshots.all(@project_id)

    assert Enum.count(screenshots.items) == 3
    assert screenshots.project_id == @project_id

    screenshot = hd(screenshots.items)
    assert screenshot.screenshot_id == 100_001
  end

  test "lists paginated screenshots" do
    response = %{
      project_id: @project_id,
      screenshots: screenshots(2)
    }

    params = [page: 2, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/screenshots")

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

    {:ok, %ScreenshotsCollection{} = screenshots} =
      Screenshots.all(@project_id, params)

    assert Enum.count(screenshots.items) == 2
    assert screenshots.project_id == @project_id
    assert screenshots.total_count == 3
    assert screenshots.page_count == 2
    assert screenshots.per_page_limit == 2
    assert screenshots.current_page == 2

    refute screenshots |> Pagination.first_page?()
    assert screenshots |> Pagination.last_page?()
    refute screenshots |> Pagination.next_page?()
    assert screenshots |> Pagination.prev_page?()

    screenshot = hd(screenshots.items)
    assert screenshot.screenshot_id == 100_001
  end

  test "finds a screenshot" do
    screenshot_id = 757_672

    response = %{
      project_id: @project_id,
      screenshot: screenshot_by_id(0, screenshot_id)
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/screenshots/#{screenshot_id}")

      response
      |> ok()
    end)

    {:ok, %ScreenshotModel{} = screenshot} = Screenshots.find(@project_id, screenshot_id)

    assert screenshot.screenshot_id == screenshot_id
    assert screenshot.key_ids == []
    assert String.starts_with?(screenshot.url, "https://fake.example.com/screens")
    assert screenshot.title == "Shot 0"
    assert screenshot.description == ""
    assert screenshot.screenshot_tags == []
    assert screenshot.width == 100
    assert screenshot.height == 50
    assert screenshot.created_at == "2021-01-01 00:00:00 (Etc/UTC)"
    assert screenshot.created_at_timestamp == 1_600_000_000
  end

  test "creates screenshots" do
    data = %{
      screenshots: [
        %{
          data: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIW2P4//8/AwAI/AL+X2NDNwAAAABJRU5ErkJggg==",
          title: "Shot 1"
        }
      ]
    }

    response = %{
      project_id: @project_id,
      screenshots: screenshots(1),
      errors: []
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/screenshots", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %ScreenshotsCollection{} = screenshots} = Screenshots.create(@project_id, data)
    assert screenshots.project_id == @project_id
    assert screenshots.errors == []

    screenshot = hd(screenshots.items)

    assert screenshot.title == "Shot 1"
  end

  test "updates a screenshot" do
    screenshot_id = 757_683

    data = %{
      title: "Shot 100",
      description: ""
    }

    response = %{
      project_id: @project_id,
      screenshot: screenshot_by_id(100, screenshot_id)
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/screenshots/#{screenshot_id}", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %ScreenshotModel{} = screenshot} =
      Screenshots.update(@project_id, screenshot_id, data)

    assert screenshot.title == "Shot 100"
    assert screenshot.screenshot_id == screenshot_id
    assert screenshot.description == ""
  end

  test "deletes a screenshot" do
    screenshot_id = 757_683

    response = %{
      project_id: @project_id,
      screenshot_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/screenshots/#{screenshot_id}",
        "DELETE"
      )

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Screenshots.delete(@project_id, screenshot_id)

    assert resp.project_id == @project_id
    assert resp.screenshot_deleted
  end

  defp screenshot(n, id \\ nil) do
    %{
      screenshot_id: id || 100_000 + n,
      title: "Shot #{n}",
      description: "",
      screenshot_tags: [],
      url: fake_url(n),
      key_ids: [],
      width: 100 + n,
      height: 50 + n,
      created_at: "2021-01-01 00:00:0#{n} (Etc/UTC)",
      created_at_timestamp: 1_600_000_000 + n
    }
  end

  defp screenshots(n \\ 3) do
    for index <- 1..n, do: screenshot(index)
  end

  defp screenshot_by_id(n, id), do: screenshot(n, id)

  defp fake_url(i) do
    hash =
      :crypto.strong_rand_bytes(20)
      |> Base.encode16(case: :lower)

    "https://fake.example.com/screens/#{@project_id}/#{hash}_#{i}.jpg"
  end
end
