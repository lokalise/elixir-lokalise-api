# Queued processes

## Fetch queued processes

[Doc](https://developers.lokalise.com/reference/list-all-processes)

```elixir
{:ok, processes} = ElixirLokaliseApi.QueuedProcesses.all(project_id, page: 2, limit: 1)
```

## Fetch a single queued process

[Doc](https://developers.lokalise.com/reference/retrieve-a-process)

```elixir
{:ok, process} = ElixirLokaliseApi.QueuedProcesses.find(project_id, process_id)

process.type
```
