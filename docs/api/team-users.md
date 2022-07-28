# Team users

## Fetch team users

[Doc](https://developers.lokalise.com/reference/list-all-team-users

```elixir
{:ok, users} = ElixirLokaliseApi.TeamUsers.all(team_id, limit: 1, page: 2)

user = hd(users.items)
user.user_id
```

## Fetch a single team user

[Doc](https://developers.lokalise.com/reference/retrieve-a-team-user

```elixir
{:ok, user} = ElixirLokaliseApi.TeamUsers.find(team_id, user_id)

user.user_id
```

## Update team user

[Doc](https://developers.lokalise.com/reference/update-a-team-user

```elixir
data = %{
  role: "admin"
}

{:ok, user} = ElixirLokaliseApi.TeamUsers.update(team_id, user_id, data)

user.user_id
```

## Delete team user

[Doc](https://developers.lokalise.com/reference/delete-a-team-user

```elixir
{:ok, resp} = ElixirLokaliseApi.TeamUsers.delete(team_id, user_id)

resp.team_user_deleted
```
