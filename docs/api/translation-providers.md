# Translation providers

## Fetch translation providers

[Doc](https://developers.lokalise.com/reference/list-all-providers)

```elixir
{:ok, translation_providers} = ElixirLokaliseApi.TranslationProviders.all(team_id, page: 2, limit: 1)

provider = hd(translation_providers.items)
provider.provider_id
```

## Fetch a single translation provider

[Doc](https://developers.lokalise.com/reference/retrieve-a-provider)

```elixir
{:ok, provider} = ElixirLokaliseApi.TranslationProviders.find(team_id, provider_id)

provider.provider_id
```
