defmodule ElixirLokaliseApi.PaymentCardsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.PaymentCards
  alias ElixirLokaliseApi.Model.PaymentCard, as: PaymentCardModel
  alias ElixirLokaliseApi.Collection.PaymentCards, as: PaymentCardsCollection

  setup_all do
    HTTPoison.start()
  end

  doctest PaymentCards

  test "lists all payment cards" do
    use_cassette "payment_cards_all" do
      {:ok, %PaymentCardsCollection{} = cards} = PaymentCards.all()
      card = hd(cards.items)

      assert cards.user_id == 20181
      assert card.card_id == 1774
    end
  end

  test "lists paginated payment cards" do
    use_cassette "payment_cards_paginated" do
      {:ok, %PaymentCardsCollection{} = cards} = PaymentCards.all(page: 2, limit: 2)

      assert Enum.count(cards.items) == 2
      assert cards.total_count == 4
      assert cards.page_count == 2
      assert cards.per_page_limit == 2
      assert cards.current_page == 2

      refute cards |> Pagination.first_page?()
      assert cards |> Pagination.last_page?()
      refute cards |> Pagination.next_page?()
      assert cards |> Pagination.prev_page?()

      card = hd(cards.items)
      assert card.card_id == 3574
    end
  end

  test "finds a payment card" do
    use_cassette "payment_card_find" do
      card_id = 1774
      {:ok, %PaymentCardModel{} = card} = PaymentCards.find(card_id)

      assert card.card_id == card_id
      assert card.brand == "Visa"
      assert card.created_at == "2019-03-19 17:49:07 (Etc/UTC)"
      assert card.created_at_timestamp == 1_553_017_747
      assert card.last4 == "0358"
    end
  end

  test "creates a payment card" do
    use_cassette "payment_card_create" do
      data = %{
        number: "1212121212121212",
        cvc: 123,
        exp_month: 3,
        exp_year: 2030
      }

      {:ok, %PaymentCardModel{} = card} = PaymentCards.create(data)

      assert card.card_id == 4207
      assert card.brand == "Visa"
    end
  end

  test "deletes a payment card" do
    use_cassette "payment_card_delete" do
      {:ok, %{} = resp} = PaymentCards.delete(4207)
      assert resp.card_deleted
    end
  end
end
