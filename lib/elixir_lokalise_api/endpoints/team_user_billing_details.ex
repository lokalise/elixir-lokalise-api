defmodule ElixirLokaliseApi.TeamUserBillingDetails do
  @moduledoc """
  Team user billing details endpoint.
  """

  use ElixirLokaliseApi.DynamicResource,
    import: [
      :find,
      :create2,
      :update2
    ]

  alias ElixirLokaliseApi.Model.TeamUserBillingDetails

  @collection nil
  @data_key nil
  @singular_data_key nil
  @model TeamUserBillingDetails
  @endpoint "teams/{!:team_id}/billing_details"
  @parent_key :team_id
end
