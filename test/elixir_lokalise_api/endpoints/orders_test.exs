defmodule ElixirLokaliseApi.OrdersTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Orders
  alias ElixirLokaliseApi.Model.Order, as: OrderModel
  alias ElixirLokaliseApi.Collection.Orders, as: OrdersCollection

  doctest Orders

  @team_id 176_692
  @project_id "217830385f9c0fdbd589f0.91420183"

  test "lists all orders" do
    orders =
      for i <- 1..3 do
        %{order_id: "abc#{i}", project_id: @project_id}
      end

    response = %{
      orders: orders
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/orders")

      response
      |> ok()
    end)

    {:ok, %OrdersCollection{} = orders} = Orders.all(@team_id)

    assert Enum.count(orders.items) == 3

    order = hd(orders.items)
    assert order.order_id == "abc1"
  end

  test "lists paginated orders" do
    orders =
      for i <- 1..2 do
        %{order_id: "abc#{i}", project_id: @project_id}
      end

    response = %{
      orders: orders
    }

    params = [page: 3, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/orders")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "6"},
        {"x-pagination-page-count", "3"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "3"}
      ])
    end)

    {:ok, %OrdersCollection{} = orders} = Orders.all(@team_id, params)

    assert Enum.count(orders.items) == 2
    assert orders.total_count == 6
    assert orders.page_count == 3
    assert orders.per_page_limit == 2
    assert orders.current_page == 3

    refute orders |> Pagination.first_page?()
    assert orders |> Pagination.last_page?()
    refute orders |> Pagination.next_page?()
    assert orders |> Pagination.prev_page?()

    order = hd(orders.items)
    assert order.order_id == "abc1"
  end

  test "finds an order" do
    order_id = "20200122FTR"

    response = %{
      order_id: order_id,
      project_id: @project_id,
      branch: nil,
      payment_method: nil,
      card_id: 2185,
      status: "completed",
      created_at: "2020-01-22 12:04:15 (Etc/UTC)",
      created_at_timestamp: 1_579_694_655,
      created_by: 20_181,
      created_by_email: "user@example.com",
      source_language_iso: "en",
      target_language_isos: ["lv"],
      keys: [35_400_063, 35_400_274, 35_434_575],
      source_words: %{lv: 3},
      provider_slug: "gengo",
      translation_style: "friendly",
      translation_tier: 1,
      translation_tier_name: "Professional translator",
      briefing: "test",
      total: 0.21
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/orders/#{order_id}")

      response
      |> ok()
    end)

    {:ok, %OrderModel{} = order} = Orders.find(@team_id, order_id)

    assert order.order_id == order_id
    assert order.project_id == @project_id
    refute order.branch
    refute order.payment_method
    assert order.card_id == 2185
    assert order.status == "completed"
    assert order.created_at == "2020-01-22 12:04:15 (Etc/UTC)"
    assert order.created_at_timestamp == 1_579_694_655
    assert order.created_by == 20181
    assert order.created_by_email == "user@example.com"
    assert order.source_language_iso == "en"
    assert order.target_language_isos == ["lv"]
    assert order.keys == [35_400_063, 35_400_274, 35_434_575]
    assert order.source_words == %{lv: 3}
    assert order.provider_slug == "gengo"
    assert order.translation_style == "friendly"
    assert order.translation_tier == 1
    assert order.translation_tier_name == "Professional translator"
    assert order.briefing == "test"
    assert order.total == 0.21
    refute order.dry_run
  end

  test "creates an order" do
    key_id = "79039607"

    data = %{
      project_id: @project_id,
      card_id: 2185,
      briefing: "Sample",
      source_language_iso: "en",
      target_language_isos: ["fr"],
      keys: [79_039_607],
      provider_slug: "google",
      translation_tier: 1,
      dry_run: true
    }

    response = %{
      order_id: "123abc",
      project_id: @project_id,
      branch: nil,
      payment_method: nil,
      card_id: 2185,
      status: "completed",
      source_language_iso: "en",
      target_language_isos: ["fr"],
      keys: [key_id],
      provider_slug: "google",
      briefing: "Sample",
      total: 0.21,
      dry_run: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/orders", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %OrderModel{} = order} = Orders.create(@team_id, data)

    assert order.dry_run
    assert order.keys == [key_id]
    assert order.provider_slug == "google"
  end
end
