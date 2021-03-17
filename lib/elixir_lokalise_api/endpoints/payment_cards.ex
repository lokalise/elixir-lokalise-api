defmodule ElixirLokaliseApi.PaymentCards do
  @moduledoc """
  Payment cards endpoint.
  """
  @model ElixirLokaliseApi.Model.PaymentCard
  @collection ElixirLokaliseApi.Collection.PaymentCards
  @endpoint "payment_cards/{:card_id}"
  @data_key :payment_cards
  @singular_data_key :payment_card
  @parent_key :card_id

  use ElixirLokaliseApi.DynamicResource, import: [:find, :all, :create, :delete]
end
