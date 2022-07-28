# Snapshots

## Fetch snapshots

[Doc](https://developers.lokalise.com/reference/list-all-snapshots

```elixir
{:ok, snapshots} = ElixirLokaliseApi.Snapshots.all(project_id, page: 2, limit: 1)

snapshot = hd(snapshots.items)
snapshot.snapshot_id
```

## Create snapshot

[Doc](https://developers.lokalise.com/reference/create-a-snapshot

```elixir
data = %{
  title: "Elixir snap"
}

{:ok, snapshot} = ElixirLokaliseApi.Snapshots.create(project_id, data)
snapshot.title
```

## Restore snapshot

[Doc](https://developers.lokalise.com/reference/restore-a-snapshot

```elixir
{:ok, project} = ElixirLokaliseApi.Snapshots.restore(project_id, snapshot_id)

project.project_id
```

## Delete snapshot

[Doc](https://developers.lokalise.com/reference/delete-a-snapshot

```elixir
{:ok, resp} = ElixirLokaliseApi.Snapshots.delete(project_id, snapshot_id)

resp.snapshot_deleted
```
