# Getting Started

## Installation and Requirements

This package is tested with [Elixir 1.2+](https://elixir-lang.org/).

Add it to the `mix.exs` file:

```elixir
def deps do
  [
    {:elixir_lokalise_api}
  ]
end
```

## Initializing the Client

In order to perform API requests, you require a special token that can be obtained in your [personal profile](https://lokalise.com/profile#apitokens) (*API tokens* section).

After you've obtained the token, put it inside `config.exs`:

```elixir
config :elixir_lokalise_api, api_token: "LOKALISE_API_TOKEN"
```

If you are using ENV variables, use the following approach:

```elixir
config :elixir_lokalise_api, api_token: {:system, "ENV_VARIABLE_NAME"}
```

If you are using OAuth 2 tokens:

```elixir
config :elixir_lokalise_api, oauth2_token: "YOUR_API_OAUTH2_TOKEN"
```

Update OAuth 2 tokens on the fly:

```elixir
:oauth2_token |> ElixirLokaliseApi.Config.put_env(oauth2_token)
```

Now you can send API requests!

## Objects and models

Individual objects are represented as Elixir structs which are called *models*. Each model responds to the methods that are named after the API object's attributes.

Here is an example:

```elixir
{:ok, project} = ElixirLokaliseApi.Projects.find("123.abc")

project.name
project.description
project.base_language_iso
```

You can also use pattern matching:

```elixir
{:ok, %ElixirLokaliseApi.Model.Project{} = project} = ElixirLokaliseApi.Projects.find("123.abc")
```

Many resources have common methods like `project_id` and `branch`:

```elixir
{:ok, webhook} = ElixirLokaliseApi.Webhooks.find("123.abc", "345def")
webhook.project_id
webhook.branch
```

## Collections of resources and pagination

Fetching (or creating/updating) multiple objects will return a *collection* of objects represented as a struct. To get access to the actual data, use the `items` attribute. Each item of the collection is usually represented as a model struct:

```elixir
{:ok, %ElixirLokaliseApi.Collection.Projects{} = projects} = ElixirLokaliseApi.Projects.all()

project = hd projects.items # => Get the first project from the collection

%ElixirLokaliseApi.Model.Project{} = project # => project is a model struct

project.name # => you can fetch attributes easily
project.description
```

Bulk fetches support [pagination](https://app.lokalise.com/api2docs/curl/#resource-pagination). There are two common parameters available:

* `:limit` (defaults to `100`, maximum is `5000`) - number of records to display per page
* `:page` (defaults  to `1`) - page to fetch

```elixir
{:ok, projects} = ElixirLokaliseApi.Projects.all(page: 3, limit: 10) #=> Paginate by 10 records and fetch the third page
```

Paginated collections have the following attributes:

```elixir
projects.total_count # => Total number of items
projects.page_count # => Total number of pages
projects.per_page_limit # => The number of items per page
projects.current_page # => Currently requested page number
```

To work with pagination data, use the `ElixirLokaliseApi.Pagination` module:

```elixir
projects |> ElixirLokaliseApi.Pagination.first_page?() # => Is this the first page?
projects |> ElixirLokaliseApi.Pagination.last_page?() # => Is this the last page?
projects |> ElixirLokaliseApi.Pagination.next_page?() # => Is there a next page available?
projects |> ElixirLokaliseApi.Pagination.prev_page?() # => Is there a previous page available?
projects |> Pagination.next_page() # => What is the number of the next page?
projects |> Pagination.prev_page() # => What is the number of the previous page?
```

## Branching

If you are using [project branching feature](https://docs.lokalise.com/en/articles/3391861-project-branching), simply add branch name separated by semicolon to your project ID in any endpoint to access the branch. For example, in order to access `new-feature` branch for the project with an id `123abcdef.01`:

```elixir
{:ok, files} = ElixirLokaliseApi.Files.all("123abcdef.01:new-feature")

files.project_id # => "123abcdef.01"
files.branch # => "new-feature"

file = hd files.items
file.filename
```
