# Custom translation statuses

[Translation Status attributes](https://app.lokalise.com/api2docs/curl/#object-translation-statuses)

*Custom translation statuses must be enabled for the project before using this endpoint!* It can be done in the project settings.

## Fetch translation statuses

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-custom-translation-statuses-get)

```elixir
{:ok, statuses} = ElixirLokaliseApi.TranslationStatuses.all(project_id, page: 2, limit: 1)

status = hd(statuses.items)
status.status_id
```

## Fetch a single translation status

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-custom-translation-status-get)

```elixir
{:ok, status} = ElixirLokaliseApi.TranslationStatuses.find(project_id, status_id)

status.status_id
```

## Create translation status

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-custom-translation-status-post)

```elixir
data = %{
  title: "elixir",
  color: "#344563"
}

{:ok, status} = ElixirLokaliseApi.TranslationStatuses.create(project_id, data)

status.title
```

## Update translation status

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-custom-translation-status-put)

```elixir
data = %{
  title: "elixir-upd"
}

{:ok, status} = ElixirLokaliseApi.TranslationStatuses.update(project_id, status_id, data)

status.title
```

## Delete translation status

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-custom-translation-status-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.TranslationStatuses.delete(project_id, status_id)

resp.custom_translation_status_deleted
```

## Supported color codes for translation statuses

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-available-colors-for-custom-translation-statuses-get)

As long as Lokalise supports only very limited array of color hexadecimal codes for custom translation statuses, this method can be used to fetch all permitted values.

```elixir
{:ok, resp} = ElixirLokaliseApi.TranslationStatuses.available_colors(project_id)

resp.colors
```
