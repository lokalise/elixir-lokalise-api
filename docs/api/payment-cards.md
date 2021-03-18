# Payment cards

[Payment card attributes](https://app.lokalise.com/api2docs/curl/#object-payment-cards)

## Fetch payment cards

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-cards-get)

```elixir
@client.payment_cards(params = {})    # Input:
                                      ## params (hash)
                                      ### :page and :limit
                                      # Output:
                                      ## Collection of payment cards under the `payment_cards` attribute
```

## Fetch a single payment card

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-card-get)

```elixir
@client.payment_card(card_id)     # Input:
                                  ## card_id (string, required)
                                  # Output:
                                  ## A single payment card
```

## Create a payment card

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-card-post)

```elixir
@client.create_payment_card(params)   # Input:
                                      ## params (hash, required)
                                      ### number (integer, string, required) - card number
                                      ### cvc (integer, required) - 3-digit card CVV (CVC)
                                      ### exp_month (integer, required) - card expiration month (1 - 12)
                                      ### exp_year (integer, required) - card expiration year (for example, 2019)
                                      # Output:
                                      ## A newly created payment card

```

## Delete a payment card

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-card-delete)

```elixir
@client.destroy_payment_card(card_id)   # Input:
                                        ## card_id (integer, string, required)
                                        # Output:
                                        ## Hash containing card id and `card_deleted => true` attribute
```

Alternatively:

```elixir
card = @client.payment_card('card_id')
card.destroy
```
