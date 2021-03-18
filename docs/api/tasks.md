# Tasks

[Task attributes](https://app.lokalise.com/api2docs/curl/#resource-tasks)

## Fetch tasks

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-tasks-get)

```elixir
{:ok, tasks} = ElixirLokaliseApi.Tasks.all(project_id, page: 2, limit: 1, filter_statuses: "completed")

task = hd(tasks.items)
task.task_id
```

## Fetch a single task

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-task-get)

```elixir
{:ok, task} = ElixirLokaliseApi.Tasks.find(project_id, task_id)
task.task_id
```

## Create task

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-task-post)

```elixir
data = %{
  title: "Elixir",
  keys: [74_185, 74_187],
  languages: [
    %{
      language_iso: "sq",
      users: [2018]
    }
  ]
}

{:ok, task} = ElixirLokaliseApi.Tasks.create(project_id, data)

task.title
```

## Update task

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-task-put)

```elixir
data = %{
  title: "Elixir updated",
  description: "sample"
}

{:ok, task} = ElixirLokaliseApi.Tasks.update(project_id, task_id, data)

task.task_id
```

## Delete task

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-task-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Tasks.delete(project_id, task_id)

resp.task_deleted
```
