defmodule ElixirLokaliseApi.PaymentCards do
  @moduledoc """
  Payment cards endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:find, :all, :create, :delete]

  alias ElixirLokaliseApi.Collection.PaymentCards
  alias ElixirLokaliseApi.Model.PaymentCard

  @model PaymentCard
  @collection PaymentCards
  @endpoint "payment_cards/{:card_id}"
  @data_key :payment_cards
  @singular_data_key :payment_card
  @parent_key :card_id
end
