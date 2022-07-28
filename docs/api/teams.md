# Teams

## Fetch teams

[Doc](https://developers.lokalise.com/reference/list-all-teams)

```elixir
{:ok, teams} = ElixirLokaliseApi.Teams.all(page: 2, limit: 3)

team = hd(teams.items)
team.team_id
```
