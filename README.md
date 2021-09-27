# ElixirLokaliseApi

[![Build Status](https://travis-ci.com/lokalise/elixir-lokalise-api.svg?branch=master)](https://app.travis-ci.com/github/lokalise/elixir-lokalise-api)
[![Coverage Status](https://coveralls.io/repos/github/lokalise/elixir-lokalise-api/badge.svg)](https://coveralls.io/github/lokalise/elixir-lokalise-api)
[![Module Version](https://img.shields.io/hexpm/v/elixir_lokalise_api.svg)](https://hex.pm/packages/elixir_lokalise_api)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/elixir_lokalise_api/)
[![Total Download](https://img.shields.io/hexpm/dt/elixir_lokalise_api.svg)](https://hex.pm/packages/elixir_lokalise_api)
[![License](https://img.shields.io/hexpm/l/elixir_lokalise_api.svg)](https://github.com/elixir-lokalise-api/elixir_lokalise_api/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/lokalise/elixir-lokalise-api.svg)](https://github.com/lokalise/elixir-lokalise-api/commits/master)

Official Elixir interface for Lokalise APIv2.

## Quickstart

Add a new dependency to `mix.exs`:

```elixir
def deps do
  [
    {:elixir_lokalise_api, "~> 2.0"}
  ]
end
```

Put your Lokalise API token into `config.exs`:

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

## Documentation

All documentation and usage examples can be found at [lokalise.github.io/elixir-lokalise-api](https://lokalise.github.io/elixir-lokalise-api/).

Brief API reference is also available at [hexdocs.pm](https://hexdocs.pm/elixir_lokalise_api/).

## Copyright and License

Licensed under the [BSD 3 Clause license](./LICENSE.md).

Copyright (c) 2021 Lokalise team and [Ilya Bodrov](http://bodrovis.tech)
