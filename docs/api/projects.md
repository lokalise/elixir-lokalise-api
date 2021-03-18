# Projects

[Project attributes](https://app.lokalise.com/api2docs/curl/#object-projects)

## Fetch projects

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-projects-get)

```elixir
{:ok, projects} = ElixirLokaliseApi.Projects.all(page: 3, limit: 2)
project = projects.items |> hd
project.name
```

## Fetch a single project

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-project-get)

```elixir
{:ok, project} = ElixirLokaliseApi.Projects.find(project_id)

project.project_id
```

## Create a project

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-project-post)

```elixir
project_data = %{name: "Elixir SDK", description: "Created via API"}
{:ok, project} = ElixirLokaliseApi.Projects.create(project_data)
project.name
```

## Update a project

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-project-put)

```elixir
project_data = %{name: "Updated SDK", description: "Updated via API"}

{:ok, project} = ElixirLokaliseApi.Projects.update(project_id, project_data)
project.project_id
```

## Empty a project

[Doc](https://app.lokalise.com/api2docs/curl/#transition-empty-a-project-put)

Deletes *all* keys and translations from the project.

```elixir
{:ok, resp} = ElixirLokaliseApi.Projects.empty(project_id)
resp.keys_deleted
```

## Delete a project

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-project-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Projects.delete(project_id)
resp.project_deleted
```