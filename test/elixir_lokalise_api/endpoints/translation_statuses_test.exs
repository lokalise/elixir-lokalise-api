defmodule ElixirLokaliseApi.TranslationStatusesTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.TranslationStatuses, as: TranslationStatusesCollection
  alias ElixirLokaliseApi.Model.TranslationStatus, as: TranslationStatusModel
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TranslationStatuses

  doctest TranslationStatuses

  @project_id "287061316050d93a27ada8.24068671"
  @status_id 2967

  test "lists all translation statuses" do
    response = %{
      project_id: @project_id,
      custom_translation_statuses: [
        %{
          status_id: @status_id,
          title: "demo",
          color: "#ff78cb"
        },
        %{
          status_id: 2965,
          title: "sample",
          color: "#61bd4f"
        },
        %{
          status_id: 2966,
          title: "test",
          color: "#f2d600"
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/custom_translation_statuses")

      response
      |> ok()
    end)

    {:ok, %TranslationStatusesCollection{} = statuses} = TranslationStatuses.all(@project_id)

    assert Enum.count(statuses.items) == 3

    status = hd(statuses.items)
    assert status.status_id == @status_id
  end

  test "lists paginated translation statuses" do
    response = %{
      project_id: @project_id,
      custom_translation_statuses: [
        %{
          status_id: @status_id,
          title: "demo",
          color: "#ff78cb"
        },
        %{
          status_id: 2965,
          title: "sample",
          color: "#61bd4f"
        }
      ]
    }

    params = [page: 2, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/custom_translation_statuses")

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

    {:ok, %TranslationStatusesCollection{} = statuses} =
      TranslationStatuses.all(@project_id, params)

    assert Enum.count(statuses.items) == 2
    assert statuses.total_count == 4
    assert statuses.page_count == 2
    assert statuses.per_page_limit == 2
    assert statuses.current_page == 2

    refute statuses |> Pagination.first_page?()
    assert statuses |> Pagination.last_page?()
    refute statuses |> Pagination.next_page?()
    assert statuses |> Pagination.prev_page?()

    status = hd(statuses.items)
    assert status.status_id == @status_id
  end

  test "finds a translation status" do
    response = %{
      project_id: @project_id,
      custom_translation_status: %{
        status_id: @status_id,
        title: "sample",
        color: "#61bd4f"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/custom_translation_statuses/#{@status_id}")

      response
      |> ok()
    end)

    {:ok, %TranslationStatusModel{} = status} = TranslationStatuses.find(@project_id, @status_id)

    assert status.status_id == @status_id
    assert status.title == "sample"
    assert status.color == "#61bd4f"
  end

  test "creates a translation status" do
    data = %{
      title: "elixir",
      color: "#344563"
    }

    response = %{
      project_id: @project_id,
      custom_translation_status: %{
        status_id: 2968,
        title: "elixir",
        color: "#344563"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/custom_translation_statuses",
        "POST"
      )

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TranslationStatusModel{} = status} = TranslationStatuses.create(@project_id, data)

    assert status.title == "elixir"
    assert status.color == "#344563"
  end

  test "updates a translation status" do
    data = %{
      title: "elixir-upd"
    }

    response = %{
      project_id: @project_id,
      custom_translation_status: %{
        status_id: @status_id,
        title: "elixir-upd",
        color: "#344563"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/custom_translation_statuses/#{@status_id}",
        "PUT"
      )

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TranslationStatusModel{} = status} =
      TranslationStatuses.update(@project_id, @status_id, data)

    assert status.title == "elixir-upd"
    assert status.status_id == @status_id
  end

  test "deletes a translation status" do
    response = %{
      project_id: @project_id,
      custom_translation_status_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/custom_translation_statuses/#{@status_id}",
        "DELETE"
      )

      response
      |> ok()
    end)

    {:ok, %{} = resp} = TranslationStatuses.delete(@project_id, @status_id)

    assert resp.project_id == @project_id
    assert resp.custom_translation_status_deleted
  end

  test "shows available colors for statuses" do
    response = %{
      colors: [
        "#61bd4f",
        "#f2d600",
        "#ff9f1a"
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/custom_translation_statuses/colors")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = TranslationStatuses.available_colors(@project_id)

    assert hd(resp.colors) == "#61bd4f"
  end
end
