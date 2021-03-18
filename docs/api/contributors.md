# Contributors

## Fetch contributors

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-contributors-get)

```elixir
{:ok, contributors} = ElixirLokaliseApi.Contributors.all(project_id, page: 2, limit: 1)

contributor = hd contributors.items
contributor.user_id
```

## Fetch a single contributor

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-contributor-get)

```elixir
{:ok, contributor} = ElixirLokaliseApi.Contributors.find(project_id, contributor_id)

contributor.user_id
```

## Create contributors

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-contributors-post)

```elixir
data = %{
  contributors: [
    %{
      email: "elixir_test@example.com",
      fullname: "Elixir Rocks",
      languages: [
        %{
          lang_iso: "en",
          is_writable: false
        }
      ]
    }
  ]
}

{:ok, contributors} = ElixirLokaliseApi.Contributors.create(project_id, data)

contributor = hd contributors.items
contributor.email
```

## Update contributor

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-contributor-put)

```elixir
data = %{
  is_reviewer: true
}

{:ok, contributor} = ElixirLokaliseApi.Contributors.update(project_id, contributor_id, data)

contributor.user_id
```

## Delete contributor

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-contributor-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Contributors.delete(project_id, contributor_id)

resp.contributor_deleted
```
