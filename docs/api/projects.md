# Projects

## Fetch projects

[Doc](https://developers.lokalise.com/reference/list-all-projects

```elixir
{:ok, projects} = ElixirLokaliseApi.Projects.all(page: 3, limit: 2)
project = projects.items |> hd
project.name
```

## Fetch a single project

[Doc](https://developers.lokalise.com/reference/retrieve-a-project

```elixir
{:ok, project} = ElixirLokaliseApi.Projects.find(project_id)

project.project_id
```

## Create a project

[Doc](https://developers.lokalise.com/reference/create-a-project

```elixir
project_data = %{name: "Elixir SDK", description: "Created via API"}
{:ok, project} = ElixirLokaliseApi.Projects.create(project_data)
project.name
```

## Update a project

[Doc](https://developers.lokalise.com/reference/update-a-project

```elixir
project_data = %{name: "Updated SDK", description: "Updated via API"}

{:ok, project} = ElixirLokaliseApi.Projects.update(project_id, project_data)
project.project_id
```

## Empty a project

[Doc](https://developers.lokalise.com/reference/empty-a-project

Deletes *all* keys and translations from the project.

```elixir
{:ok, resp} = ElixirLokaliseApi.Projects.empty(project_id)
resp.keys_deleted
```

## Delete a project

[Doc](https://developers.lokalise.com/reference/delete-a-project

```elixir
{:ok, resp} = ElixirLokaliseApi.Projects.delete(project_id)
resp.project_deleted
```