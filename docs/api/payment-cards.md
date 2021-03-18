# Payment cards

[Payment card attributes](https://app.lokalise.com/api2docs/curl/#object-payment-cards)

## Fetch payment cards

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-cards-get)

```elixir
{:ok, cards} = ElixirLokaliseApi.PaymentCards.all(page: 2, limit: 2)

card = hd(cards.items)
card.card_id
```

## Fetch a single payment card

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-card-get)

```elixir
{:ok, card} = ElixirLokaliseApi.PaymentCards.find(card_id)

card.card_id
```

## Create a payment card

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-card-post)

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

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-card-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.PaymentCards.delete(card_id)
resp.card_deleted
```
