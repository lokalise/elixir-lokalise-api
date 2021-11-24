defmodule ElixirLokaliseApi.TeamUserBillingDetails do
  @moduledoc """
  Team user billing details endpoint.
  """

  @collection nil
  @data_key nil
  @singular_data_key nil
  @model ElixirLokaliseApi.Model.TeamUserBillingDetails
  @endpoint "teams/{!:team_id}/billing_details"
  @parent_key :team_id

  use ElixirLokaliseApi.DynamicResource,
    import: [
      :find,
      :create2,
      :update2
    ]
end
