defmodule ElixirLokaliseApi.OrdersTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Orders
  alias ElixirLokaliseApi.Model.Order, as: OrderModel
  alias ElixirLokaliseApi.Collection.Orders, as: OrdersCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Orders

  @team_id 176_692

  test "lists all orders" do
    use_cassette "orders_all" do
      {:ok, %OrdersCollection{} = orders} = Orders.all(@team_id)

      assert Enum.count(orders.items) == 12

      order = hd(orders.items)
      assert order.order_id == "201903198B2"
    end
  end

  test "lists paginated orders" do
    use_cassette "orders_all_paginated" do
      {:ok, %OrdersCollection{} = orders} = Orders.all(@team_id, page: 3, limit: 2)

      assert Enum.count(orders.items) == 2
      assert orders.total_count == 12
      assert orders.page_count == 6
      assert orders.per_page_limit == 2
      assert orders.current_page == 3

      refute orders |> Pagination.first_page?()
      refute orders |> Pagination.last_page?()
      assert orders |> Pagination.next_page?()
      assert orders |> Pagination.prev_page?()

      order = hd(orders.items)
      assert order.order_id == "20200122FTR"
    end
  end

  test "finds an order" do
    use_cassette "order_find" do
      order_id = "20200122FTR"
      {:ok, %OrderModel{} = order} = Orders.find(@team_id, order_id)

      assert order.order_id == order_id
      assert order.project_id == "124505395e2074d880f724.35422706"
      refute order.branch
      refute order.payment_method
      assert order.card_id == 2185
      assert order.status == "completed"
      assert order.created_at == "2020-01-22 12:04:15 (Etc/UTC)"
      assert order.created_at_timestamp == 1_579_694_655
      assert order.created_by == 20181
      assert order.created_by_email == "bodrovis@protonmail.com"
      assert order.source_language_iso == "en"
      assert order.target_language_isos == ["ru_RU"]
      assert order.keys == [35_400_063, 35_400_274, 35_434_575]
      assert order.source_words == %{ru_RU: 3}
      assert order.provider_slug == "gengo"
      assert order.translation_style == "friendly"
      assert order.translation_tier == 1
      assert order.translation_tier_name == "Professional translator"
      assert order.briefing == "test"
      assert order.total == 0.21
      refute order.dry_run
    end
  end

  test "creates an order" do
    use_cassette "order_create" do
      data = %{
        project_id: "572560965f984614d567a4.18006942",
        card_id: 2185,
        briefing: "Sample",
        source_language_iso: "en",
        target_language_isos: ["fr"],
        keys: [79_039_607],
        provider_slug: "google",
        translation_tier: 1,
        dry_run: true
      }

      {:ok, %OrderModel{} = order} = Orders.create(@team_id, data)

      assert order.dry_run
      assert order.keys == ["79039607"]
      assert order.provider_slug == "google"
    end
  end
end
