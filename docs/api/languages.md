# Languages

## Fetch system languages

[Doc](https://developers.lokalise.com/reference/list-system-languages

```elixir
{:ok, languages} = ElixirLokaliseApi.SystemLanguages.all(page: 3, limit: 2)

language = hd(languages.items)
language.lang_iso
```

## Fetch project languages

[Doc](https://developers.lokalise.com/reference/list-project-languages

```elixir
{:ok, languages} = ElixirLokaliseApi.ProjectLanguages.all(project_id, page: 3, limit: 2)

language = languages.items |> hd
language.lang_iso
```

## Fetch a single project language

[Doc](https://developers.lokalise.com/reference/retrieve-a-language

```elixir
{:ok, language} = ElixirLokaliseApi.ProjectLanguages.find(project_id, lang_id)

language.lang_id
```

## Create project languages

[Doc](https://developers.lokalise.com/reference/create-languages

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

[Doc](https://developers.lokalise.com/reference/update-a-language

```elixir
data = %{
  lang_name: "Updated"
}

{:ok, language} = ElixirLokaliseApi.ProjectLanguages.update(project_id, lang_id, data)

language.lang_name
```

## Delete project language

[Doc](https://developers.lokalise.com/reference/delete-a-language

```elixir
{:ok, resp} = ElixirLokaliseApi.ProjectLanguages.delete(project_id, lang_id)
resp.language_deleted
```
