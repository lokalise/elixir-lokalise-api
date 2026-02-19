defmodule ElixirLokaliseApi.PaymentCardsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.PaymentCards
  alias ElixirLokaliseApi.Model.PaymentCard, as: PaymentCardModel
  alias ElixirLokaliseApi.Collection.PaymentCards, as: PaymentCardsCollection

  doctest PaymentCards

  @user_id 123

  test "lists all payment cards" do
    response = %{
      user_id: @user_id,
      payment_cards: [
        %{
          card_id: 1774,
          last4: "1234",
          brand: "Visa",
          created_at: "2019-03-19 17:49:07 (Etc/UTC)",
          created_at_timestamp: 1_553_017_747
        },
        %{
          card_id: 2185,
          last4: "4321",
          brand: "MasterCard",
          created_at: "2019-06-19 15:51:54 (Etc/UTC)",
          created_at_timestamp: 1_560_959_514
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/payment_cards")

      response
      |> ok()
    end)

    {:ok, %PaymentCardsCollection{} = cards} = PaymentCards.all()
    card = hd(cards.items)

    assert cards.user_id == @user_id
    assert card.card_id == 1774
  end

  test "lists paginated payment cards" do
    response = %{
      user_id: @user_id,
      payment_cards: [
        %{
          card_id: 1774,
          last4: "1234",
          brand: "Visa",
          created_at: "2019-03-19 17:49:07 (Etc/UTC)",
          created_at_timestamp: 1_553_017_747
        },
        %{
          card_id: 2185,
          last4: "4321",
          brand: "MasterCard",
          created_at: "2019-06-19 15:51:54 (Etc/UTC)",
          created_at_timestamp: 1_560_959_514
        }
      ]
    }

    params = [page: 2, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/payment_cards")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "4"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %PaymentCardsCollection{} = cards} = PaymentCards.all(params)

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
    assert card.card_id == 1774
  end

  test "finds a payment card" do
    card_id = 1774

    response = %{
      user_id: @user_id,
      payment_card: %{
        card_id: card_id,
        last4: "1234",
        brand: "Visa",
        created_at: "2019-03-19 17:49:07 (Etc/UTC)",
        created_at_timestamp: 1_553_017_747
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/payment_cards/#{card_id}")

      response
      |> ok()
    end)

    {:ok, %PaymentCardModel{} = card} = PaymentCards.find(card_id)

    assert card.card_id == card_id
    assert card.brand == "Visa"
    assert card.created_at == "2019-03-19 17:49:07 (Etc/UTC)"
    assert card.created_at_timestamp == 1_553_017_747
    assert card.last4 == "1234"
  end

  test "creates a payment card" do
    data = %{
      number: "1212121212121212",
      cvc: 123,
      exp_month: 3,
      exp_year: 2030
    }

    response = %{
      card_id: 4207,
      last4: "1212",
      brand: "Visa",
      created_at: "2021-03-15 18:08:57 (Etc/UTC)",
      created_at_timestamp: 1_615_831_737
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/payment_cards", "POST")

      req |> assert_json_body(data)

      response |> ok()
    end)

    {:ok, %PaymentCardModel{} = card} = PaymentCards.create(data)

    assert card.card_id == 4207
    assert card.brand == "Visa"
  end

  test "deletes a payment card" do
    card_id = 4207
    response = %{card_id: card_id, card_deleted: true}

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/payment_cards/#{card_id}", "DELETE")

      response |> ok()
    end)

    {:ok, %{} = resp} = PaymentCards.delete(card_id)
    assert resp.card_deleted
    assert resp.card_id == card_id
  end
end
