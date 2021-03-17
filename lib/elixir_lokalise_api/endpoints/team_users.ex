defmodule ElixirLokaliseApi.TeamUsers do
  @model ElixirLokaliseApi.Model.TeamUser
  @collection ElixirLokaliseApi.Collection.TeamUsers
  @endpoint "teams/{!:team_id}/users/{:user_id}"
  @data_key :team_users
  @singular_data_key :team_user
  @parent_key :team_id
  @item_key :user_id

  use ElixirLokaliseApi.DynamicResource,
    import: [:item_reader, :all2, :find2, :update3, :delete2]
end
