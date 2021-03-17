defmodule ElixirLokaliseApi.WebhooksTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Webhooks
  alias ElixirLokaliseApi.Collection.Webhooks, as: WebhooksCollection
  alias ElixirLokaliseApi.Model.Webhook, as: WebhookModel

  setup_all do
    HTTPoison.start()
  end

  doctest Webhooks

  @project_id "803826145ba90b42d5d860.46800099"

  test "lists all webhooks" do
    use_cassette "webhooks_all" do
      {:ok, %WebhooksCollection{} = webhooks} = Webhooks.all(@project_id)

      assert Enum.count(webhooks.items) == 3

      webhook = hd(webhooks.items)
      assert webhook.webhook_id == "795565582e5ab15a59bb68156c7e2e9eaa1e8d1a"
    end
  end

  test "lists paginated webhooks" do
    use_cassette "webhooks_all_paginated" do
      {:ok, %WebhooksCollection{} = webhooks} = Webhooks.all(@project_id, page: 2, limit: 1)

      assert Enum.count(webhooks.items) == 1
      assert webhooks.total_count == 3
      assert webhooks.page_count == 3
      assert webhooks.per_page_limit == 1
      assert webhooks.current_page == 2

      refute webhooks |> Pagination.first_page?()
      refute webhooks |> Pagination.last_page?()
      assert webhooks |> Pagination.next_page?()
      assert webhooks |> Pagination.prev_page?()

      webhook = hd(webhooks.items)
      assert webhook.webhook_id == "c7eb7e6e3c2fb2b26d0b64d0de083a5a71675b3d"
    end
  end

  test "regenerates webhook secret" do
    use_cassette "webhook_regenerate_secret" do
      webhook_id = "795565582e5ab15a59bb68156c7e2e9eaa1e8d1a"
      {:ok, %{} = resp} = Webhooks.regenerate_secret(@project_id, webhook_id)

      assert resp.project_id == @project_id
      assert resp.secret == "53209c0033c5371d2935f3fc8f91fdfd9aa61419"
    end
  end
end
