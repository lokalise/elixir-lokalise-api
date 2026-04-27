defmodule ElixirLokaliseApi.PermissionTemplates do
  @moduledoc """
  Permission templates endpoint.
  """
  use ElixirLokaliseApi.DynamicResource, import: [:all2]

  alias ElixirLokaliseApi.Collection.PermissionTemplates
  alias ElixirLokaliseApi.Model.PermissionTemplate

  @model PermissionTemplate
  @collection PermissionTemplates
  @endpoint "teams/{!:team_id}/roles"
  @data_key :roles
  @singular_data_key nil
  @parent_key :team_id
end
