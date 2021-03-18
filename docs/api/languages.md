# Languages

[Language attributes](https://app.lokalise.com/api2docs/curl/#object-languages)

## Fetch system languages

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-system-languages-get)

```elixir
{:ok, languages} = ElixirLokaliseApi.SystemLanguages.all(page: 3, limit: 2)

language = hd(languages.items)
language.lang_iso
```

## Fetch project languages

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-project-languages-get)

```elixir
{:ok, languages} = ElixirLokaliseApi.ProjectLanguages.all(project_id, page: 3, limit: 2)

language = languages.items |> hd
language.lang_iso
```

## Fetch a single project language

[Doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-language-get)

```elixir
{:ok, language} = ElixirLokaliseApi.ProjectLanguages.find(project_id, lang_id)

language.lang_id
```

## Create project languages

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-languages-post)

```elixir
data = %{
  languages: [
    %{
      lang_iso: "fr",
      custom_iso: "samp"
    },
    %{
      lang_iso: "de",
      custom_name: "Sample"
    }
  ]
}

{:ok, languages} = ElixirLokaliseApi.ProjectLanguages.create(project_id, data)
languages.items
```

## Update project language

[Doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-language-put)

```elixir
data = %{
  lang_name: "Updated"
}

{:ok, language} = ElixirLokaliseApi.ProjectLanguages.update(project_id, lang_id, data)

language.lang_name
```

## Delete project language

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-language-delete)

```elixir
{:ok, resp} = ElixirLokaliseApi.ProjectLanguages.delete(project_id, lang_id)
resp.language_deleted
```
