# Translations

## Fetch translations

[Doc](https://developers.lokalise.com/reference/list-all-translations)

**This endpoint also supports cursor pagination which is now a recommended approach, especially for fetching large amounts of data. Please [learn more in the Pagination docs](https://lokalise.github.io/elixir-lokalise-api/api/getting-started#cursor-pagination).**

```elixir
{:ok, translations} = ElixirLokaliseApi.Translations.all(@project_id, filter_is_reviewed: 0, page: 2, limit: 1)

translation = hd(translations.items)
translation.translation_id
```

## Fetch a single translation

[Doc](https://developers.lokalise.com/reference/retrieve-a-translation)

```elixir
{:ok, translation} = ElixirLokaliseApi.Translations.find(project_id, translation_id, disable_references: 1)

translation.translation_id
```

## Update translation

[Doc](https://developers.lokalise.com/reference/update-a-translation)

```elixir
data = %{
  translation: "Updated!",
  is_reviewed: true
}

{:ok, translation} = ElixirLokaliseApi.Translations.update(project_id, translation_id, data)

translation.translation_id
```
