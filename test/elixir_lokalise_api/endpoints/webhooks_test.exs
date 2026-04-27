defmodule ElixirLokaliseApi.WebhooksTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.Webhooks, as: WebhooksCollection
  alias ElixirLokaliseApi.Model.Webhook, as: WebhookModel
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Webhooks

  doctest Webhooks

  @project_id "803826145ba90b42d5d860.46800099"
  @webhook_id "795565582e5ab15a59bb68156c7e2e9eaa1e8d1a"

  test "lists all webhooks" do
    response = %{
      project_id: "803826145ba90b42d5d860.46800099",
      webhooks: [
        %{
          webhook_id: @webhook_id
        },
        %{
          webhook_id: "c7eb7e6e3c2fb2b26d0b64d0de083a5a71675b3d"
        },
        %{
          webhook_id: "b1a98c63f7e8a03b1c7aadc0a8171d637b7a9e02"
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/webhooks")

      response
      |> ok()
    end)

    {:ok, %WebhooksCollection{} = webhooks} = Webhooks.all(@project_id)

    assert Enum.count(webhooks.items) == 3

    webhook = hd(webhooks.items)
    assert webhook.webhook_id == @webhook_id
  end

  test "lists paginated webhooks" do
    response = %{
      project_id: "803826145ba90b42d5d860.46800099",
      webhooks: [
        %{
          webhook_id: @webhook_id,
          url: "https://serios.webhook"
        },
        %{
          webhook_id: "c7eb7e6e3c2fb2b26d0b64d0de083a5a71675b3d",
          url: "https://canihaz.hook"
        }
      ]
    }

    params = [page: 2, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/webhooks")

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

    {:ok, %WebhooksCollection{} = webhooks} = Webhooks.all(@project_id, params)

    assert Enum.count(webhooks.items) == 2
    assert webhooks.total_count == 4
    assert webhooks.page_count == 2
    assert webhooks.per_page_limit == 2
    assert webhooks.current_page == 2

    refute webhooks |> Pagination.first_page?()
    assert webhooks |> Pagination.last_page?()
    refute webhooks |> Pagination.next_page?()
    assert webhooks |> Pagination.prev_page?()

    webhook = hd(webhooks.items)
    assert webhook.webhook_id == @webhook_id
  end

  test "finds a webhook" do
    response = %{
      project_id: @project_id,
      webhook: %{
        webhook_id: @webhook_id,
        url: "https://serios.webhook",
        branch: nil,
        secret: "53209c0033c5371d2935f3fc8f91fdfd9aa61419",
        events: [
          "project.imported",
          "project.key.added",
          "project.keys.deleted",
          "project.translation.updated"
        ],
        event_lang_map: [
          %{
            event: "project.translation.updated",
            lang_iso_codes: ["nl"]
          }
        ]
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/webhooks/#{@webhook_id}")

      response
      |> ok()
    end)

    {:ok, %WebhookModel{} = webhook} = Webhooks.find(@project_id, @webhook_id)

    assert webhook.webhook_id == @webhook_id
    assert webhook.url == "https://serios.webhook"
    refute webhook.branch
    assert webhook.secret == "53209c0033c5371d2935f3fc8f91fdfd9aa61419"
    assert hd(webhook.events) == "project.imported"
    assert hd(webhook.event_lang_map).event == "project.translation.updated"
  end

  test "creates a webhook" do
    data = %{
      url: "http://bodrovis.tech/lokalise",
      events: ["project.imported"]
    }

    response = %{
      project_id: @project_id,
      webhook: %{
        webhook_id: "836f910af4130a788600978fb21680b8ca349fa8",
        url: "http://example.com/lokalise",
        branch: nil,
        secret: "123abc",
        events: ["project.imported"],
        event_lang_map: []
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/webhooks", "POST")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %WebhookModel{} = webhook} = Webhooks.create(@project_id, data)

    assert webhook.url == "http://example.com/lokalise"
    assert webhook.events == ["project.imported"]
  end

  test "updates a webhook" do
    data = %{
      events: ["project.exported"]
    }

    response = %{
      project_id: @project_id,
      webhook: %{
        webhook_id: @webhook_id,
        url: "http://example.com/lokalise",
        branch: nil,
        secret: "123abc",
        events: ["project.exported"],
        event_lang_map: []
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/webhooks/#{@webhook_id}", "PUT")

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %WebhookModel{} = webhook} = Webhooks.update(@project_id, @webhook_id, data)

    assert webhook.webhook_id == @webhook_id
    assert webhook.events == ["project.exported"]
  end

  test "deletes a webhook" do
    response = %{
      project_id: @project_id,
      webhook_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/webhooks/#{@webhook_id}", "DELETE")

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Webhooks.delete(@project_id, @webhook_id)

    assert resp.project_id == @project_id
    assert resp.webhook_deleted
  end

  test "regenerates webhook secret" do
    response = %{
      project_id: @project_id,
      secret: "pass"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/webhooks/#{@webhook_id}/secret/regenerate",
        "PATCH"
      )

      response
      |> ok()
    end)

    {:ok, %{} = resp} = Webhooks.regenerate_secret(@project_id, @webhook_id)

    assert resp.project_id == @project_id
    assert resp.secret == "pass"
  end
end
