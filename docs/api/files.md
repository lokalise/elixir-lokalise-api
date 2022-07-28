# Translation files

## Fetch translation files

[Doc](https://developers.lokalise.com/reference/list-all-files

```elixir
{:ok, files} = ElixirLokaliseApi.Files.all(project_id, page: 2, limit: 3)

file = hd files.items
file.filename
```

## Download translation files

[Doc](https://developers.lokalise.com/reference/download-files

Exports project files as a `.zip` bundle and makes them available to download (the link is valid for 12 months).

```elixir
data = %{
  format: "json",
  original_filenames: true
}

{:ok, resp} = ElixirLokaliseApi.Files.download(project_id, data)

resp.bundle_url
```

## Upload translation file

[Doc](https://developers.lokalise.com/reference/upload-a-file

```elixir
data = %{
  data: "ZnI6...",
  filename: "sample.yml",
  lang_iso: "fr"
}

{:ok, process} = ElixirLokaliseApi.Files.upload(project_id, data)
process.type
process.status # => "queued"
```

Your job is to periodically check the status of the queued process:

```elixir
{:ok, process} = ElixirLokaliseApi.QueuedProcesses.find(project_id, process.process_id)

process.status # => "finished"
```

## Delete translation file

[Doc](https://developers.lokalise.com/reference/delete-a

Please note that this endpoint does not support "software localization" projects.

```elixir
{:ok, %{} = resp} = Files.delete(project_id, file_id)

resp.file_deleted # => true
resp.project_id # => "123.abc"
```