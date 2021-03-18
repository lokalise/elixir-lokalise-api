# Translations

[Translation attributes](https://app.lokalise.com/api2docs/curl/#resource-translations)

## Fetch translations

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-translations-get)

```elixir
{:ok, translations} = ElixirLokaliseApi.Translations.all(@project_id, filter_is_reviewed: 0, page: 2, limit: 1)

translation = hd(translations.items)
translation.translation_id
```

## Fetch a single translation

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-translation-get)

```elixir
{:ok, translation} = ElixirLokaliseApi.Translations.find(project_id, translation_id, disable_references: 1)

translation.translation_id
```

## Update translation

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-translation-put)

```elixir
data = %{
  translation: "Updated!",
  is_reviewed: true
}

{:ok, translation} = ElixirLokaliseApi.Translations.update(project_id, translation_id, data)

translation.translation_id
```
