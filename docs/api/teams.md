# Teams

## Fetch teams

[Doc](https://app.lokalise.com/api2docs/curl/#resource-teams)

```elixir
{:ok, teams} = ElixirLokaliseApi.Teams.all(page: 2, limit: 3)

team = hd(teams.items)
team.team_id
```
