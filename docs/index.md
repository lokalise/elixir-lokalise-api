---
layout: default
---

# Lokalise APIv2 Elixir interface

Add a new depedency to `mix.exs`:

```elixir
def deps do
  [
    {:elixir_lokalise_api}
  ]
end
```

Obtain Lokalise API token in your personal profile and put it into `config.exs`:

```elixir
config :elixir_lokalise_api, api_token: "LOKALISE_API_TOKEN"
```

If you are using ENV variables, use the following approach:

```elixir
config :elixir_lokalise_api, api_token: {:system, "LOKALISE_API_TOKEN"}
```

Now you can perform API calls:

```elixir
project_data = %{name: "Elixir", description: "Created via API"}
{:ok, project} = ElixirLokaliseApi.Projects.create(project_data)

project.name |> IO.puts # => "Elixir"

translation_data = %{
  data: "ZnI6...",
  filename: "sample.yml",
  lang_iso: "en"
}
{:ok, process} = ElixirLokaliseApi.Files.upload(project.project_id, data)

{:ok, process} = QueuedProcesses.find(project.project_id, process.process_id)

process.status |> IO.puts # => "finished"
```

## Usage

<nav class="index">
  {% include nav_full.html %}
</nav>

## Additional info

<nav class="index">
  {% include nav_full_additional.html %}
</nav>
