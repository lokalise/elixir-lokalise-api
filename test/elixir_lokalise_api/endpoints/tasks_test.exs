defmodule ElixirLokaliseApi.TasksTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Tasks
  alias ElixirLokaliseApi.Model.Task, as: TaskModel
  alias ElixirLokaliseApi.Collection.Tasks, as: TasksCollection

  doctest Tasks

  @project_id "803826145ba90b42d5d860.46800099"
  @task_id 18_493

  test "lists all tasks" do
    sample_tasks =
      for i <- 1..3 do
        %{
          task_id: 10_000 + i,
          title: "Task #{i}",
          status: "completed"
        }
      end

    response = %{
      project_id: @project_id,
      tasks: sample_tasks
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/tasks")

      response
      |> ok()
    end)

    {:ok, %TasksCollection{} = tasks} = Tasks.all(@project_id)

    assert Enum.count(tasks.items) == 3
    assert tasks.project_id == @project_id

    task = hd(tasks.items)
    assert task.task_id == 10_001
  end

  test "lists paginated tasks" do
    sample_tasks =
      for i <- 1..3 do
        %{
          task_id: 10_000 + i,
          title: "Task #{i}",
          status: "completed"
        }
      end

    response = %{
      project_id: @project_id,
      tasks: sample_tasks
    }

    params = [page: 3, limit: 2, filter_statuses: "completed"]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/tasks")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "6"},
        {"x-pagination-page-count", "3"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "3"}
      ])
    end)

    {:ok, %TasksCollection{} = tasks} =
      Tasks.all(@project_id, params)

    assert Enum.count(tasks.items) == 3
    assert tasks.project_id == @project_id
    assert tasks.total_count == 6
    assert tasks.page_count == 3
    assert tasks.per_page_limit == 2
    assert tasks.current_page == 3

    refute tasks |> Pagination.first_page?()
    assert tasks |> Pagination.last_page?()
    refute tasks |> Pagination.next_page?()
    assert tasks |> Pagination.prev_page?()

    task = hd(tasks.items)
    assert task.task_id == 10_001
  end

  test "finds a task" do
    response = %{
      project_id: @project_id,
      task: %{
        task_id: @task_id,
        title: "test",
        can_be_parent: false,
        task_type: "translation",
        parent_task_id: nil,
        closing_tags: [],
        description: "",
        status: "completed",
        progress: 0,
        due_date: nil,
        due_date_timestamp: nil,
        keys_count: 19,
        words_count: 145,
        created_at: "2019-07-11 15:56:27 (Etc/UTC)",
        created_at_timestamp: 1_562_860_587,
        created_by: 20_181,
        created_by_email: "user@example.com",
        source_language_iso: "en",
        languages: [
          %{
            language_iso: "sq",
            users: [
              %{user_id: 20_181, email: "user@example.com", fullname: "Ilya B"},
              %{user_id: 34_052, email: "user2@example.com", fullname: "Translator Demo"}
            ],
            groups: [],
            keys: [],
            status: "created",
            progress: 0,
            initial_tm_leverage: %{
              "0%+" => 0,
              "60%+" => 0,
              "75%+" => 0,
              "95%+" => 0,
              "100%" => 0
            },
            keys_count: 5,
            words_count: 4,
            completed_at: nil,
            completed_at_timestamp: nil,
            completed_by: nil,
            completed_by_email: nil
          }
        ],
        auto_close_items: true,
        auto_close_languages: true,
        auto_close_task: true,
        completed_at: "2019-10-01 11:09:09 (Etc/UTC)",
        completed_at_timestamp: 1_569_928_149,
        completed_by: 20_181,
        completed_by_email: "user@example.com",
        do_lock_translations: false,
        custom_translation_status_ids: []
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/tasks/#{@task_id}")

      response
      |> ok()
    end)

    {:ok, %TaskModel{} = task} = Tasks.find(@project_id, @task_id)

    assert task.task_id == @task_id
    assert task.title == "test"
    assert task.description == ""
    assert task.status == "completed"
    assert task.progress == 0
    refute task.due_date
    refute task.due_date_timestamp
    assert task.keys_count == 19
    assert task.words_count == 145
    assert task.created_at == "2019-07-11 15:56:27 (Etc/UTC)"
    assert task.created_at_timestamp == 1_562_860_587
    assert task.created_by == 20_181
    assert task.created_by_email == "user@example.com"
    refute task.can_be_parent
    assert task.task_type == "translation"
    refute task.parent_task_id
    assert task.closing_tags == []
    refute task.do_lock_translations
    assert hd(task.languages).language_iso == "sq"
    assert task.source_language_iso == "en"
    assert task.auto_close_languages
    assert task.auto_close_task
    assert task.auto_close_items
    assert task.completed_at == "2019-10-01 11:09:09 (Etc/UTC)"
    assert task.completed_at_timestamp == 1_569_928_149
    assert task.completed_by == 20_181
    assert task.completed_by_email == "user@example.com"
    assert task.custom_translation_status_ids == []
  end

  test "creates a task" do
    data = %{
      title: "Elixir",
      keys: [74_189_435, 74_187_003],
      languages: [
        %{
          language_iso: "sq",
          users: [20_181]
        }
      ]
    }

    response = %{
      project_id: @project_id,
      task: %{
        task_id: 10_001,
        title: "Elixir",
        status: "completed"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/tasks", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TaskModel{} = task} = Tasks.create(@project_id, data)

    assert task.title == "Elixir"
  end

  test "updates a task" do
    data = %{
      title: "Elixir updated",
      description: "sample"
    }

    response = %{
      project_id: @project_id,
      task: %{
        task_id: @task_id,
        title: "Elixir updated",
        description: "sample",
        status: "completed"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/tasks/#{@task_id}", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %TaskModel{} = task} = Tasks.update(@project_id, @task_id, data)

    assert task.task_id == @task_id
    assert task.title == "Elixir updated"
    assert task.description == "sample"
  end

  test "deletes a task" do
    response = %{
      project_id: @project_id,
      task_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/tasks/#{@task_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Tasks.delete(@project_id, @task_id)

    assert resp.task_deleted
    assert resp.project_id == @project_id
  end
end
