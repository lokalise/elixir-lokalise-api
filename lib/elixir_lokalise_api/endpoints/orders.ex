defmodule ElixirLokaliseApi.Orders do
  @moduledoc """
  Orders endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :find2, :all2, :create2]

  alias ElixirLokaliseApi.Collection.Orders
  alias ElixirLokaliseApi.Model.Order

  @model Order
  @collection Orders
  @endpoint "teams/{!:team_id}/orders/{:order_id}"
  @data_key :orders
  @singular_data_key nil
  @parent_key :team_id
  @item_key :order_id
end
