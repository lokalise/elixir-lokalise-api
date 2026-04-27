defmodule ElixirLokaliseApi.Webhooks do
  @moduledoc """
  Webhooks endpoint.
  """
  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :find2, :all2, :create2, :update3, :delete2]

  alias ElixirLokaliseApi.Collection.Webhooks
  alias ElixirLokaliseApi.Model.Webhook

  @model Webhook
  @collection Webhooks
  @endpoint "projects/{!:project_id}/webhooks/{:webhook_id}/{:_postfix}"
  @data_key :webhooks
  @singular_data_key :webhook
  @parent_key :project_id
  @item_key :webhook_id

  @doc """
  Regenerates secret key for a webhook.
  """
  def regenerate_secret(project_id, webhook_id) do
    make_request(:patch,
      data: nil,
      url_params: url_params(project_id, webhook_id) ++ [{:_postfix, "secret/regenerate"}],
      type: :raw
    )
  end
end
