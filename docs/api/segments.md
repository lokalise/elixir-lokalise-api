# Segments

## Fetch segments

[API doc](https://developers.lokalise.com/reference/list-all-segments-for-key-language

```elixir
{:ok, segments} = ElixirLokaliseApi.Segments.all(@project_id, @key_id, @lang_iso, disable_references: 1, filter_untranslated: 0)

segments.project_id

segment = hd(segments.items)
segment.value
segment.is_reviewed
```

## Fetch a single segment

[API doc](https://developers.lokalise.com/reference/retrieve-a-segment-for-key-language

```elixir
segment_number = 1
{:ok, segment} = ElixirLokaliseApi.Segments.find(@project_id, @key_id, @lang_iso, segment_number)

segment.value
segment.is_fuzzy
segment.words
```

## Update segment

[API doc](https://developers.lokalise.com/reference/update-a-segment

```elixir
segment_number = 2
segment_data = %{value: "Sample text from Elixir", is_reviewed: true}

{:ok, segment} = ElixirLokaliseApi.Segments.update(@project_id, @key_id, @lang_iso, segment_number, segment_data)

segment.value
segment.is_reviewed
```