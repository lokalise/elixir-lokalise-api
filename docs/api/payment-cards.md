# Payment cards

## Fetch payment cards

[Doc](https://developers.lokalise.com/reference/list-all-cards

```elixir
{:ok, cards} = ElixirLokaliseApi.PaymentCards.all(page: 2, limit: 2)

card = hd(cards.items)
card.card_id
```

## Fetch a single payment card

[Doc](https://developers.lokalise.com/reference/retrieve-a-card

```elixir
{:ok, card} = ElixirLokaliseApi.PaymentCards.find(card_id)

card.card_id
```

## Create a payment card

[Doc](https://developers.lokalise.com/reference/create-a-card

```elixir
data = %{
  number: "1212121212121212",
  cvc: 123,
  exp_month: 3,
  exp_year: 2030
}

{:ok, card} = ElixirLokaliseApi.PaymentCards.create(data)

card.card_id
```

## Delete a payment card

[Doc](https://developers.lokalise.com/reference/delete-a-card

```elixir
{:ok, resp} = ElixirLokaliseApi.PaymentCards.delete(card_id)
resp.card_deleted
```
