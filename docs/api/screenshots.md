# Screenshots

[Screenshot attributes](https://app.lokalise.com/api2docs/curl/#resource-screenshots)

## Fetch screenshots

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-screenshots-get)

```elixir
{:ok, screenshots} = ElixirLokaliseApi.Screenshots.all(project_id, page: 2, limit: 1)

screenshot = hd(screenshots.items)
screenshot.screenshot_id
```

## Fetch a single screenshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-screenshot-get)

```elixir
{:ok, screenshot} = ElixirLokaliseApi.Screenshots.find(project_id, screenshot_id)

screenshot.screenshot_id
```

## Create screenshots

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-screenshots-post)

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

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-screenshot-put)

```elixir
data = %{
  title: "Elixir updated",
  description: "Mix test"
}

{:ok, screenshot} = ElixirLokaliseApi.Screenshots.update(project_id, screenshot_id, data)

screenshot.title
```

## Delete screenshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-screenshot-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Screenshots.delete(project_id, screenshot_id)

resp.screenshot_deleted
```
