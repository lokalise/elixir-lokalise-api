defmodule ElixirLokaliseApi.PermissionTemplatesTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.PermissionTemplates
  alias ElixirLokaliseApi.Collection.PermissionTemplates, as: PermissionTemplatesCollection

  setup_all do
    HTTPoison.start()
  end

  doctest PermissionTemplates

  @team_id 176_692

  test "lists all team user groups" do
    use_cassette "permission_templates_all" do
      {:ok, %PermissionTemplatesCollection{} = templates} = PermissionTemplates.all(@team_id)

      assert Enum.count(templates.items) == 5

      template = hd(templates.items)
      assert template.id == 1
      assert template.role == "Manager"
      assert hd(template.permissions) == "activity"
      assert template.description == "Manage project settings, contributors and tasks"
      assert template.tag == "Full access"
      assert template.tagColor == "green"
      assert template.tagInfo == nil
      assert template.doesEnableAllReadOnlyLanguages == true
    end
  end
end
