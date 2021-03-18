# Translation providers

[Translation provider attributes](https://app.lokalise.com/api2docs/curl/#object-translation-providers)

## Fetch translation providers

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-providers-get)

```elixir
{:ok, translation_providers} = ElixirLokaliseApi.TranslationProviders.all(team_id, page: 2, limit: 1)

provider = hd(translation_providers.items)
provider.provider_id
```

## Fetch a single translation provider

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-provider-get)

```elixir
{:ok, provider} = ElixirLokaliseApi.TranslationProviders.find(team_id, provider_id)

provider.provider_id
```
