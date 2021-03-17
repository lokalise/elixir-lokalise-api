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

  test "finds a webhook" do
    use_cassette "webhook_find" do
      webhook_id = "795565582e5ab15a59bb68156c7e2e9eaa1e8d1a"
      {:ok, %WebhookModel{} = webhook} = Webhooks.find(@project_id, webhook_id)

      assert webhook.webhook_id == webhook_id
      assert webhook.url == "https://serios.webhook"
      refute webhook.branch
      assert webhook.secret == "53209c0033c5371d2935f3fc8f91fdfd9aa61419"
      assert hd(webhook.events) == "project.imported"
      assert hd(webhook.event_lang_map).event == "project.translation.updated"
    end
  end

  test "creates a webhook" do
    use_cassette "webhook_create" do
      data = %{
        url: "http://bodrovis.tech/lokalise",
        events: ["project.imported"]
      }

      {:ok, %WebhookModel{} = webhook} = Webhooks.create(@project_id, data)

      assert webhook.url == "http://bodrovis.tech/lokalise"
      assert webhook.events == ["project.imported"]
    end
  end

  test "updates a webhook" do
    use_cassette "webhook_updates" do
      webhook_id = "836f910af4130a788600978fb21680b8ca349fa8"

      data = %{
        events: ["project.exported"]
      }

      {:ok, %WebhookModel{} = webhook} = Webhooks.update(@project_id, webhook_id, data)

      assert webhook.webhook_id == webhook_id
      assert webhook.events == ["project.exported"]
    end
  end

  test "deletes a webhook" do
    use_cassette "webhook_delete" do
      webhook_id = "836f910af4130a788600978fb21680b8ca349fa8"
      {:ok, %{} = resp} = Webhooks.delete(@project_id, webhook_id)

      assert resp.project_id == @project_id
      assert resp.webhook_deleted
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
