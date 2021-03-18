# Team user groups

[Team user group attributes](https://app.lokalise.com/api2docs/curl/#object-team-user-groups)

## Fetch team user groups

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-groups-get)

```elixir
{:ok, groups} = ElixirLokaliseApi.TeamUserGroups.all(team_id, page: 3, limit: 2)

group = hd(groups.items)
group.group_id
```

## Fetch a single group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-group-get)

```elixir
{:ok, group} = ElixirLokaliseApi.TeamUserGroups.find(team_id, group_id)

group.group_id
```

## Create group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-group-post)

```elixir
data = %{
  name: "ExGroup",
  is_reviewer: true,
  is_admin: false,
  languages: %{
    reference: [],
    contributable: [640]
  }
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.create(team_id, data)

group.name
```

## Update group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-group-put)

```elixir
data = %{
  name: "ExGroup Updated",
  is_reviewer: true,
  is_admin: false,
  languages: %{
    reference: [],
    contributable: [640]
  }
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.update(team_id, group_id, data)

group.name
```

## Add projects to group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-add-projects-to-group-put)

```elixir
data = %{
  projects: [project_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.add_projects(team_id, group_id, data)

assert group.group_id
```

## Remove projects from group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-remove-projects-from-group-put)

```elixir
data = %{
  projects: [project_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.remove_projects(team_id, group_id, data)

group.group_id
```

## Add users to group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-add-members-to-group-put)

```elixir
data = %{
  users: [user_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.add_members(team_id, group_id, data)

group.group_id
```

## Remove users from group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-remove-members-from-group-put)

```elixir
data = %{
  users: [user_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.remove_members(team_id, group_id, data)

group.group_id
```

## Destroy group

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-group-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.TeamUserGroups.delete(team_id, group_id)

resp.group_deleted
```
