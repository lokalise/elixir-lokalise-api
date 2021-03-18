# ElixirLokaliseApi

[![Build Status](https://travis-ci.com/bodrovis/elixir-lokalise-api.svg?branch=master)](https://travis-ci.com/bodrovis/elixir-lokalise-api)
[![Coverage Status](https://coveralls.io/repos/github/bodrovis/elixir-lokalise-api/badge.svg)](https://coveralls.io/github/bodrovis/elixir-lokalise-api)

Official Elixir interface for Lokalise APIv2.

## Quickstart

Add a new depedency to `mix.exs`:

```elixir
def deps do
  [
    {:elixir_lokalise_api}
  ]
end
```

Put your Lokalise API token into `config.exs`:

```elixir
config :your_app, api_token: "LOKALISE_API_TOKEN"
```

If you are using ENV variables, use the following approach:

```elixir
config :your_app, api_token: {:system, "LOKALISE_API_TOKEN"}
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

## Documentation

All documentation and usage examples can be found at [bodrovis.github.io/elixir-lokalise-api](https://bodrovis.github.io/elixir-lokalise-api/).

Brief API reference is also available at [hexdocs.pm](https://hexdocs.pm/elixir_lokalise_api/).

## License

Licensed under the [BSD 3 Clause license](https://github.com/bodrovis/elixir-lokalise-api/blob/master/LICENSE).

Copyright (c) Lokalise team, [Ilya Bodrov](http://bodrovis.tech)