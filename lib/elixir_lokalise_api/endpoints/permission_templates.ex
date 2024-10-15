defmodule ElixirLokaliseApi.PermissionTemplates do
  @moduledoc """
  Permission templates endpoint.
  """
  @model ElixirLokaliseApi.Model.PermissionTemplate
  @collection ElixirLokaliseApi.Collection.PermissionTemplates
  @endpoint "teams/{!:team_id}/roles"
  @data_key :roles
  @singular_data_key nil
  @parent_key :team_id

  use ElixirLokaliseApi.DynamicResource, import: [:all2]
end
