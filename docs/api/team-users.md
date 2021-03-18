# Team users

[Team user attributes](https://app.lokalise.com/api2docs/curl/#object-team-users)

## Fetch team users

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-team-users-get)

```elixir
{:ok, users} = ElixirLokaliseApi.TeamUsers.all(team_id, limit: 1, page: 2)

user = hd(users.items)
user.user_id
```

## Fetch a single team user

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-team-user-get)

```elixir
{:ok, user} = ElixirLokaliseApi.TeamUsers.find(team_id, user_id)

user.user_id
```

## Update team user

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-team-user-put)

```elixir
data = %{
  role: "admin"
}

{:ok, user} = ElixirLokaliseApi.TeamUsers.update(team_id, user_id, data)

user.user_id
```

## Delete team user

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-team-user-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.TeamUsers.delete(team_id, user_id)

resp.team_user_deleted
```
