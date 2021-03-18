# Translation keys

[Key attributes](https://app.lokalise.com/api2docs/curl/#object-keys)

## Fetch project keys

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-keys-get)

```elixir
{:ok, keys} = ElixirLokaliseApi.Keys.all(project_id, page: 2, limit: 3)

key = hd keys.items
key.key_id
```

## Fetch a single project key

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-key-get)

```elixir
{:ok, key} = ElixirLokaliseApi.Keys.find(project_id, key_id, disable_references: "1")

key.key_id
```

## Create project keys

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-keys-post)

```elixir
data = %{
  keys: [
    %{
      key_name: %{
        web: "elixir",
        android: "elixir",
        ios: "elixir_ios",
        other: "el_other"
      },
      description: "Via API",
      platforms: ["web", "android"],
      translations: [
        %{
          language_iso: "en",
          translation: "Hi from Elixir"
        },
        %{
          language_iso: "fr",
          translation: "test"
        }
      ]
    }
  ]
}

{:ok, keys} = ElixirLokaliseApi.Keys.create(project_id, data)

key = hd keys.items
key.key_name.android
```

## Update project key

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-key-put)

```elixir
data = %{
  description: "Updated via SDK",
  tags: ["sample"]
}

{:ok, key} = ElixirLokaliseApi.Keys.update(project_id, key_id, data)

key.key_id
```

## Bulk update project keys

[Doc](https://app.lokalise.com/api2docs/curl/#transition-bulk-update-put)

```elixir
data = %{
  keys: [
    %{
      key_id: key_id,
      description: "Bulk updated via SDK",
      tags: ["sample"]
    },
    %{
      key_id: key_id2,
      platforms: ["web", "android"]
    }
  ]
}

{:ok, keys} = ElixirLokaliseApi.Keys.update_bulk(project_id, data)

keys.items
```

## Delete project key

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-key-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Keys.delete(project_id, key_id)

resp.key_removed
```

## Bulk delete project keys

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-multiple-keys-delete)

```elixir
data = %{
  keys: [
    key_id,
    key_id2
  ]
}

{:ok, resp} = ElixirLokaliseApi.Keys.delete_bulk(project_id, data)

resp.keys_removed
```
