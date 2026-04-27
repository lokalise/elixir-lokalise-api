defmodule ElixirLokaliseApi.PermissionTemplatesTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.PermissionTemplates, as: PermissionTemplatesCollection
  alias ElixirLokaliseApi.PermissionTemplates

  doctest PermissionTemplates

  @team_id 176_692

  test "lists all team permission template roles" do
    response = %{
      roles: [
        %{
          id: 1,
          role: "Manager",
          permissions: [
            "activity",
            "branches_main_modify"
          ],
          description: "Manage project settings, contributors and tasks",
          tag: "Full access",
          tagColor: "green",
          tagInfo: nil,
          doesEnableAllReadOnlyLanguages: true
        },
        %{
          id: 2,
          role: "Fake"
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/teams/#{@team_id}/roles")

      response
      |> ok()
    end)

    {:ok, %PermissionTemplatesCollection{} = templates} = PermissionTemplates.all(@team_id)

    assert Enum.count(templates.items) == 2

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
