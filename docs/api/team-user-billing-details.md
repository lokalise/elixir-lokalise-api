# Team user billing details

[Team user billing details attributes](https://app.lokalise.com/api2docs/curl/#object-team-user-billing-details)

## Fetch team user billing details

[API doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-team-user-billing-details-get)

```elixir
team_id = 1234
{:ok, %DetailsModel{} = details} = TeamUserBillingDetails.find(team_id)

details.billing_email # => "hello@example.com"
details.country_code # => "LV"
```

## Create team user billing details

[API doc](https://app.lokalise.com/api2docs/curl/#transition-create-team-user-billing-details-post)

```elixir
team_id = 1234
data = %{
  billing_email: "hi@example.com",
  country_code: "LV",
  zip: "LV-0123"
}

{:ok, %DetailsModel{} = details} = TeamUserBillingDetails.create(team_id, data)

details.zip # => "LV-0123"
```

## Update team user billing details

[API doc](https://app.lokalise.com/api2docs/curl/#transition-update-team-user-billing-details-put)

```elixir
team_id = 1234
data = %{
  billing_email: "updated@example.com",
  country_code: "LV",
  zip: "LV-7890"
}

{:ok, %DetailsModel{} = details} = TeamUserBillingDetails.update(team_id, data)

details.zip # => "LV-7890"
```