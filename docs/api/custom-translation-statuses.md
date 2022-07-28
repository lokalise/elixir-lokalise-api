# Custom translation statuses

*Custom translation statuses must be enabled for the project before using this endpoint!* It can be done in the project settings.

## Fetch translation statuses

[Doc](https://developers.lokalise.com/reference/list-all-custom-translation-statuses

```elixir
{:ok, statuses} = ElixirLokaliseApi.TranslationStatuses.all(project_id, page: 2, limit: 1)

status = hd(statuses.items)
status.status_id
```

## Fetch a single translation status

[Doc](https://developers.lokalise.com/reference/retrieve-a-custom-translation-status

```elixir
{:ok, status} = ElixirLokaliseApi.TranslationStatuses.find(project_id, status_id)

status.status_id
```

## Create translation status

[Doc](https://developers.lokalise.com/reference/create-a-custom-translation-status

```elixir
data = %{
  title: "elixir",
  color: "#344563"
}

{:ok, status} = ElixirLokaliseApi.TranslationStatuses.create(project_id, data)

status.title
```

## Update translation status

[Doc](https://developers.lokalise.com/reference/update-a-custom-translation-status

```elixir
data = %{
  title: "elixir-upd"
}

{:ok, status} = ElixirLokaliseApi.TranslationStatuses.update(project_id, status_id, data)

status.title
```

## Delete translation status

[Doc](https://developers.lokalise.com/reference/delete-a-custom-translation-status

```elixir
{:ok, resp} = ElixirLokaliseApi.TranslationStatuses.delete(project_id, status_id)

resp.custom_translation_status_deleted
```

## Supported color codes for translation statuses

[Doc](https://developers.lokalise.com/reference/retrieve-available-colors-for-custom-translation-statuses

As long as Lokalise supports only very limited array of color hexadecimal codes for custom translation statuses, this method can be used to fetch all permitted values.

```elixir
{:ok, resp} = ElixirLokaliseApi.TranslationStatuses.available_colors(project_id)

resp.colors
```
