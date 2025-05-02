# Glossary terms

## List glossary terms

[API doc](https://developers.lokalise.com/reference/list-glossary-terms)

```elixir
{:ok, glossary_terms} = GlossaryTerms.all(@project_id, limit: 2, cursor: "5319746")

glossary_term = glossary_terms.items |> List.first()

glossary_term.term # => "sample term"
```

## Fetch a glossary term

[API doc](https://developers.lokalise.com/reference/retrieve-a-glossary-term)

```elixir
term_id = 5_319_746
{:ok, glossary_term} = GlossaryTerms.find(@project_id, term_id)

glossary_term.term # => "router"
glossary_term.description # => "A commonly used network device"
```

## Create glossary terms

[API doc](https://developers.lokalise.com/reference/create-glossary-terms)

```elixir
data = %{
  terms: [
    %{
      term: "elixir",
      description: "language",
      caseSensitive: false,
      translatable: false,
      forbidden: false
    }
  ]
}

{:ok, glossary_terms} = GlossaryTerms.create(@project_id, data)

glossary_term = hd(glossary_terms.items)

glossary_term.term # => "elixir"
glossary_term.description # => "language"
```

## Update glossary terms

[API doc](https://developers.lokalise.com/reference/update-glossary-terms)

```elixir
data = %{
  terms: [
    %{
      id: 1234,
      description: "elixir updated",
      tags: ["sample"]
    },
    %{
      id: 5789,
      caseSensitive: true
    }
  ]
}

{:ok, glossary_terms} = GlossaryTerms.update_bulk(@project_id, data)

glossary_term = hd(glossary_terms)

glossary_term.description # => "elixir updated"
```

## Delete glossary terms

[API doc](https://developers.lokalise.com/reference/delete-glossary-terms)

```elixir
data = %{
  terms: [
    12345,
    6789
  ]
}

{:ok, %{} = response} = GlossaryTerms.delete_bulk(@project_id, data)

response[:data][:deleted][:count] # => 2
```