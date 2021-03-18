# Translation orders

[Order attributes](https://app.lokalise.com/api2docs/curl/#object-orders)

## Fetch orders

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-orders-get)

```elixir
{:ok, orders} = ElixirLokaliseApi.Orders.all(team_id, page: 3, limit: 2)

order = hd(orders.items)
order.order_id
```

## Fetch a single order

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-an-order-get)

```elixir
{:ok, order} = ElixirLokaliseApi.Orders.find(team_id, order_id)
order.order_id
```

## Create an order

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-an-order-post)

```elixir
data = %{
  project_id: "572560965f984614d567a4.18006942",
  card_id: 1111,
  briefing: "Sample",
  source_language_iso: "en",
  target_language_isos: ["fr"],
  keys: [7921],
  provider_slug: "google",
  translation_tier: 1
}

{:ok, order} = ElixirLokaliseApi.Orders.create(team_id, data)

order.keys
```
