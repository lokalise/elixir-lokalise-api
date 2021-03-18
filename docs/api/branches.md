# Branches

[Branches attributes](https://app.lokalise.com/api2docs/curl/#resource-branches)

## Fetch branches

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-branches-get)

```elixir
{:ok, branches} = ElixirLokaliseApi.Branches.all(project_id, page: 2, limit: 1)

branch = hd branches.items
branch.name
```

## Fetch branch

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-branch-get)

```elixir
{:ok, branch} = ElixirLokaliseApi.Branches.find(project_id, branch_id)

branch.branch_id
branch.name
```

## Create branch

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-branch-get)

```elixir
data = %{name: "Elixir"}

{:ok, branch} = ElixirLokaliseApi.Branches.create(project_id, data)

branch.name
```

## Update branch

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-branch-put)

```elixir
data = %{name: "Elixir-update"}

{:ok, branch} = ElixirLokaliseApi.Branches.update(project_id, branch_id, data)

branch.name
```

## Delete branch

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-branch-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Branches.delete(project_id, branch_id)

resp.branch_deleted
```

## Merge branch

[Doc](https://app.lokalise.com/api2docs/curl/#transition-merge-a-branch-post)

```elixir
data = %{force_conflict_resolve_using: "target", target_branch_id: target_branch_id}

{:ok, resp} = ElixirLokaliseApi.Branches.merge(project_id, branch_id, data)

resp.branch_merged
```