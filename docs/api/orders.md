# Translation orders

## Fetch orders

[Doc](https://developers.lokalise.com/reference/list-all-orders)

```elixir
{:ok, orders} = ElixirLokaliseApi.Orders.all(team_id, page: 3, limit: 2)

order = hd(orders.items)
order.order_id
```

## Fetch a single order

[Doc](https://developers.lokalise.com/reference/retrieve-an-order)

```elixir
{:ok, order} = ElixirLokaliseApi.Orders.find(team_id, order_id)
order.order_id
```

## Create an order

[Doc](https://developers.lokalise.com/reference/create-an-order)

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
