# Snapshots

[Snapshot attributes](https://app.lokalise.com/api2docs/curl/#object-snapshots)

## Fetch snapshots

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-snapshots-get)

```elixir
{:ok, snapshots} = ElixirLokaliseApi.Snapshots.all(project_id, page: 2, limit: 1)

snapshot = hd(snapshots.items)
snapshot.snapshot_id
```

## Create snapshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-snapshot-post)

```elixir
data = %{
  title: "Elixir snap"
}

{:ok, snapshot} = ElixirLokaliseApi.Snapshots.create(project_id, data)
snapshot.title
```

## Restore snapshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-restore-a-snapshot-post)

```elixir
{:ok, project} = ElixirLokaliseApi.Snapshots.restore(project_id, snapshot_id)

project.project_id
```

## Delete snapshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-snapshot-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Snapshots.delete(project_id, snapshot_id)

resp.snapshot_deleted
```
