# Translation files

[File attributes](https://app.lokalise.com/api2docs/curl/#object-files)

## Fetch translation files

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-files-get)

```elixir
{:ok, files} = ElixirLokaliseApi.Files.all(project_id, page: 2, limit: 3)

file = hd files.items
file.filename
```

## Download translation files

[Doc](https://app.lokalise.com/api2docs/curl/#transition-download-files-post)

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

[Doc](https://app.lokalise.com/api2docs/curl/#transition-upload-a-file-post)

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