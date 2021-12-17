# Segments

[Segment attributes](https://app.lokalise.com/api2docs/curl/#object-segments)

## Fetch segments

[API doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-segments-for-key-language-get)

```elixir
{:ok, segments} = ElixirLokaliseApi.Segments.all(@project_id, @key_id, @lang_iso, disable_references: 1, filter_untranslated: 0)

segments.project_id

segment = hd(segments.items)
segment.value
segment.is_reviewed
```

## Fetch a single segment

[API doc](https://app.lokalise.com/api2docs/curl/#transition-retrieve-a-segment-for-key-language-get)

```elixir
segment_number = 1
{:ok, segment} = ElixirLokaliseApi.Segments.find(@project_id, @key_id, @lang_iso, segment_number)

segment.value
segment.is_fuzzy
segment.words
```

## Update segment

[API doc](https://app.lokalise.com/api2docs/curl/#transition-update-a-segment-put)

```elixir
segment_number = 2
segment_data = %{value: "Sample text from Elixir", is_reviewed: true}

{:ok, segment} = ElixirLokaliseApi.Segments.update(@project_id, @key_id, @lang_iso, segment_number, segment_data)

segment.value
segment.is_reviewed
```