# Teams

## Fetch teams

[Doc](https://developers.lokalise.com/reference/list-all-teams)

```elixir
{:ok, teams} = ElixirLokaliseApi.Teams.all(page: 2, limit: 3)

team = hd(teams.items)
team.team_id
```

## Fetch a single team

[Doc](https://developers.lokalise.com/reference/get-team-details)

```elixir
{:ok, team} = ElixirLokaliseApi.Teams.find(12345)

team.name # => "My Team"
```