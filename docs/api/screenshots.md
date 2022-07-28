# Screenshots

## Fetch screenshots

[Doc](https://developers.lokalise.com/reference/list-all-screenshots)

```elixir
{:ok, screenshots} = ElixirLokaliseApi.Screenshots.all(project_id, page: 2, limit: 1)

screenshot = hd(screenshots.items)
screenshot.screenshot_id
```

## Fetch a single screenshot

[Doc](https://developers.lokalise.com/reference/retrieve-a-screenshot)

```elixir
{:ok, screenshot} = ElixirLokaliseApi.Screenshots.find(project_id, screenshot_id)

screenshot.screenshot_id
```

## Create screenshots

[Doc](https://developers.lokalise.com/reference/create-screenshots)

```elixir
data = %{
  screenshots: [
    %{
      data: base64_data,
      title: "Elixir screen"
    }
  ]
}

{:ok, screenshots} = ElixirLokaliseApi.Screenshots.create(project_id, data)

screenshot = hd(screenshots.items)
screenshot.title
```

## Update screenshot

[Doc](https://developers.lokalise.com/reference/update-a-screenshot)

```elixir
data = %{
  title: "Elixir updated",
  description: "Mix test"
}

{:ok, screenshot} = ElixirLokaliseApi.Screenshots.update(project_id, screenshot_id, data)

screenshot.title
```

## Delete screenshot

[Doc](https://developers.lokalise.com/reference/delete-a-screenshot)

```elixir
{:ok, resp} = ElixirLokaliseApi.Screenshots.delete(project_id, screenshot_id)

resp.screenshot_deleted
```
