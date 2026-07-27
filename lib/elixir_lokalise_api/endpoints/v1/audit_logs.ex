defmodule ElixirLokaliseApi.V1.AuditLogs do
  @moduledoc """
  AuditLogs endpoint.
  """
  use ElixirLokaliseApi.DynamicResource,
    import: [
      :item_reader,
      :all
    ]

  alias ElixirLokaliseApi.Collection.V1.AuditLogs
  alias ElixirLokaliseApi.Model.V1.AuditLog

  @model AuditLog
  @collection AuditLogs
  @endpoint "audit-logs"
  @data_key :data
  @item_key :class_uid
  @parent_key nil
  @singular_data_key nil

  def request_for, do: :api_v1
end
