defmodule ElixirLokaliseApi.TasksTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Tasks
  alias ElixirLokaliseApi.Model.Task, as: TaskModel
  alias ElixirLokaliseApi.Collection.Tasks, as: TasksCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Tasks

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all tasks" do
    use_cassette "tasks_all" do
      {:ok, %TasksCollection{} = tasks} = Tasks.all(@project_id)

      assert Enum.count(tasks.items) == 4
      assert tasks.project_id == @project_id

      task = hd(tasks.items)
      assert task.task_id == 21659
    end
  end

  test "lists paginated tasks" do
    use_cassette "tasks_all_paginated" do
      {:ok, %TasksCollection{} = tasks} = Tasks.all(@project_id, page: 2, limit: 1, filter_statuses: "completed")

      assert Enum.count(tasks.items) == 1
      assert tasks.project_id == @project_id
      assert tasks.total_count == 4
      assert tasks.page_count == 4
      assert tasks.per_page_limit == 1
      assert tasks.current_page == 2

      refute tasks |> Pagination.first_page?()
      refute tasks |> Pagination.last_page?()
      assert tasks |> Pagination.next_page?()
      assert tasks |> Pagination.prev_page?()

      task = hd(tasks.items)
      assert task.task_id == 18493
    end
  end

  test "finds a task" do
    use_cassette "task_find" do
      task_id = 18493
      {:ok, %TaskModel{} = task} = Tasks.find(@project_id, task_id)

      assert task.task_id == task_id
      assert task.title == "test"
      assert task.description == ""
      assert task.status == "completed"
      assert task.progress == 0
      refute task.due_date
      refute task.due_date_timestamp
      assert task.keys_count == 19
      assert task.words_count == 145
      assert task.created_at == "2019-07-11 15:56:27 (Etc/UTC)"
      assert task.created_at_timestamp == 1562860587
      assert task.created_by == 20181
      assert task.created_by_email == "bodrovis@protonmail.com"
      refute task.can_be_parent
      assert task.task_type == "translation"
      refute task.parent_task_id
      assert task.closing_tags == []
      refute task.do_lock_translations
      assert hd(task.languages).keys_count == 5
      assert task.source_language_iso == "en"
      assert task.auto_close_languages
      assert task.auto_close_task
      assert task.auto_close_items
      assert task.completed_at == "2019-10-01 11:09:09 (Etc/UTC)"
      assert task.completed_at_timestamp == 1569928149
      assert task.completed_by == 20181
      assert task.completed_by_email == "bodrovis@protonmail.com"
      assert task.custom_translation_status_ids == []
    end
  end

  test "creates a task" do
    use_cassette "task_create" do
      data = %{
        title: "Elixir",
        keys: [74189435, 74187003],
        languages: [%{
          language_iso: "sq",
          users: [20181]
        }]
      }
      {:ok, %TaskModel{} = task} = Tasks.create(@project_id, data)

      assert task.title == "Elixir"
      assert hd(task.languages).language_iso == "sq"
    end
  end

  test "updates a task" do
    use_cassette "task_update" do
      data = %{
        title: "Elixir updated",
        description: "sample"
      }
      task_id = 272547
      {:ok, %TaskModel{} = task} = Tasks.update(@project_id, task_id, data)

      assert task.task_id == task_id
      assert task.title == "Elixir updated"
      assert task.description == "sample"
    end
  end

  test "deletes a task" do
    use_cassette "task_delete" do
      task_id = 18493
      {:ok, %{} = resp} = Tasks.delete(@project_id, task_id)

      assert resp.task_deleted
      assert resp.project_id == @project_id
    end
  end
end
