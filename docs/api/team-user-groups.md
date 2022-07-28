# Team user groups

## Fetch team user groups

[Doc](https://developers.lokalise.com/reference/list-all-groups)

```elixir
{:ok, groups} = ElixirLokaliseApi.TeamUserGroups.all(team_id, page: 3, limit: 2)

group = hd(groups.items)
group.group_id
```

## Fetch a single group

[Doc](https://developers.lokalise.com/reference/retrieve-a-group)

```elixir
{:ok, group} = ElixirLokaliseApi.TeamUserGroups.find(team_id, group_id)

group.group_id
```

## Create group

[Doc](https://developers.lokalise.com/reference/create-a-group)

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

[Doc](https://developers.lokalise.com/reference/update-a-group)

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

[Doc](https://developers.lokalise.com/reference/add-projects-to-group)

```elixir
data = %{
  projects: [project_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.add_projects(team_id, group_id, data)

assert group.group_id
```

## Remove projects from group

[Doc](https://developers.lokalise.com/reference/remove-projects-from-group)

```elixir
data = %{
  projects: [project_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.remove_projects(team_id, group_id, data)

group.group_id
```

## Add users to group

[Doc](https://developers.lokalise.com/reference/add-members-to-group)

```elixir
data = %{
  users: [user_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.add_members(team_id, group_id, data)

group.group_id
```

## Remove users from group

[Doc](https://developers.lokalise.com/reference/remove-members-from-group)

```elixir
data = %{
  users: [user_id]
}

{:ok, group} = ElixirLokaliseApi.TeamUserGroups.remove_members(team_id, group_id, data)

group.group_id
```

## Destroy group

[Doc](https://developers.lokalise.com/reference/delete-a-group)

```elixir
{:ok, resp} = ElixirLokaliseApi.TeamUserGroups.delete(team_id, group_id)

resp.group_deleted
```
