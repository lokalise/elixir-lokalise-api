# Webhooks

## Fetch webhooks

[Doc](https://developers.lokalise.com/reference/list-all-webhooks

```elixir
{:ok, webhooks} = ElixirLokaliseApi.Webhooks.all(project_id, page: 2, limit: 1)

webhook = hd(webhooks.items)
webhook.webhook_id
```

## Fetch a single webhook

[Doc](https://developers.lokalise.com/reference/retrieve-a-webhook

```elixir
{:ok, webhook} = ElixirLokaliseApi.Webhooks.find(project_id, webhook_id)

webhook.webhook_id
```

## Create webhook

[Doc](https://developers.lokalise.com/reference/create-a-webhook

```elixir
data = %{
  url: "http://bodrovis.tech/lokalise",
  events: ["project.imported"]
}

{:ok, webhook} = ElixirLokaliseApi.Webhooks.create(project_id, data)

webhook.url
```

## Update webhook

[Doc](https://developers.lokalise.com/reference/update-a-webhook

```elixir
data = %{
  events: ["project.exported"]
}

{:ok, webhook} = ElixirLokaliseApi.Webhooks.update(project_id, webhook_id, data)

webhook.webhook_id
```

## Delete webhook

[Doc](https://developers.lokalise.com/reference/delete-a-webhook

```elixir
{:ok, resp} = ElixirLokaliseApi.Webhooks.delete(project_id, webhook_id)

resp.webhook_deleted
```

## Regenerate webhook secret

[Doc](https://developers.lokalise.com/reference/regenerate-a-webhook-secret

```elixir
{:ok, resp} = ElixirLokaliseApi.Webhooks.regenerate_secret(project_id, webhook_id)

resp.project_id
resp.secret
```
