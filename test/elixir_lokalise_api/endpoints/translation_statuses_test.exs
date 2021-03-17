defmodule ElixirLokaliseApi.TranslationStatusesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.TranslationStatuses
  alias ElixirLokaliseApi.Collection.TranslationStatuses, as: TranslationStatusesCollection
  alias ElixirLokaliseApi.Model.TranslationStatus, as: TranslationStatusModel

  setup_all do
    HTTPoison.start()
  end

  doctest TranslationStatuses

  @project_id "287061316050d93a27ada8.24068671"

  test "lists all translation statuses" do
    use_cassette "translation_statuses_all" do
      {:ok, %TranslationStatusesCollection{} = statuses} = TranslationStatuses.all(@project_id)

      assert Enum.count(statuses.items) == 3

      status = hd(statuses.items)
      assert status.status_id == 2967
    end
  end

  test "lists paginated translation statuses" do
    use_cassette "translation_statuses_paginated" do
      {:ok, %TranslationStatusesCollection{} = statuses} =
        TranslationStatuses.all(@project_id, page: 2, limit: 1)

      assert Enum.count(statuses.items) == 1
      assert statuses.total_count == 3
      assert statuses.page_count == 3
      assert statuses.per_page_limit == 1
      assert statuses.current_page == 2

      refute statuses |> Pagination.first_page?()
      refute statuses |> Pagination.last_page?()
      assert statuses |> Pagination.next_page?()
      assert statuses |> Pagination.prev_page?()

      status = hd(statuses.items)
      assert status.status_id == 2965
    end
  end

  test "finds a translation status" do
    use_cassette "translation_status_find" do
      status_id = 2965
      {:ok, %TranslationStatusModel{} = status} = TranslationStatuses.find(@project_id, status_id)

      assert status.status_id == status_id
      assert status.title == "sample"
      assert status.color == "#61bd4f"
    end
  end

  test "creates a translation status" do
    use_cassette "translation_status_create" do
      data = %{
        title: "elixir",
        color: "#344563"
      }

      {:ok, %TranslationStatusModel{} = status} = TranslationStatuses.create(@project_id, data)

      assert status.title == "elixir"
      assert status.color == "#344563"
    end
  end

  test "updates a translation status" do
    use_cassette "translation_status_update" do
      status_id = 2968

      data = %{
        title: "elixir-upd"
      }

      {:ok, %TranslationStatusModel{} = status} =
        TranslationStatuses.update(@project_id, status_id, data)

      assert status.title == "elixir-upd"
      assert status.status_id == status_id
    end
  end

  test "deletes a translation status" do
    use_cassette "translation_status_delete" do
      status_id = 2968
      {:ok, %{} = resp} = TranslationStatuses.delete(@project_id, status_id)

      assert resp.project_id == @project_id
      assert resp.custom_translation_status_deleted
    end
  end

  test "shows available colors for statuses" do
    use_cassette "translation_status_available_colors" do
      {:ok, %{} = resp} = TranslationStatuses.available_colors(@project_id)

      assert hd(resp.colors) == "#61bd4f"
    end
  end
end
