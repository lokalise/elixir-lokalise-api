# Queued processes

[Queued processes attributes](https://app.lokalise.com/api2docs/curl/#object-queued-processes)

## Fetch queued processes

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-processes-get)

```elixir
{:ok, processes} = ElixirLokaliseApi.QueuedProcesses.all(project_id, page: 2, limit: 1)
```

## Fetch a single queued process

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-process-get)

```elixir
{:ok, process} = ElixirLokaliseApi.QueuedProcesses.find(project_id, process_id)

process.type
```
