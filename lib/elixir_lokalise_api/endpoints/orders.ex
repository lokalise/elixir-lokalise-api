defmodule ElixirLokaliseApi.Orders do
  @model ElixirLokaliseApi.Model.Order
  @collection ElixirLokaliseApi.Collection.Orders
  @endpoint "teams/{!:team_id}/orders/{:order_id}"
  @data_key :orders
  @singular_data_key nil
  @parent_key :team_id
  @item_key :order_id

  use ElixirLokaliseApi.DynamicResource, import: [:item_reader, :find2, :all2, :create2]
end
