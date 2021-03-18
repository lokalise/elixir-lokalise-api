# Webhooks

[Webhook attributes](https://app.lokalise.com/api2docs/curl/#object-webhooks)

## Fetch webhooks

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-webhooks-get)

```elixir
{:ok, webhooks} = ElixirLokaliseApi.Webhooks.all(project_id, page: 2, limit: 1)

webhook = hd(webhooks.items)
webhook.webhook_id
```

## Fetch a single webhook

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-webhook-get)

```elixir
{:ok, webhook} = ElixirLokaliseApi.Webhooks.find(project_id, webhook_id)

webhook.webhook_id
```

## Create webhook

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-webhook-post)

```elixir
data = %{
  url: "http://bodrovis.tech/lokalise",
  events: ["project.imported"]
}

{:ok, webhook} = ElixirLokaliseApi.Webhooks.create(project_id, data)

webhook.url
```

## Update webhook

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-webhook-put)

```elixir
data = %{
  events: ["project.exported"]
}

{:ok, webhook} = ElixirLokaliseApi.Webhooks.update(project_id, webhook_id, data)

webhook.webhook_id
```

## Delete webhook

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-webhook-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.Webhooks.delete(project_id, webhook_id)

resp.webhook_deleted
```

## Regenerate webhook secret

[Doc](https://app.lokalise.com/api2docs/curl/#transition-regenerate-a-webhook-secret-patch)

```elixir
{:ok, resp} = ElixirLokaliseApi.Webhooks.regenerate_secret(project_id, webhook_id)

resp.project_id
resp.secret
```
