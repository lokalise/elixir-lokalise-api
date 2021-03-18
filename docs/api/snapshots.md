# Snapshots

[Snapshot attributes](https://app.lokalise.com/api2docs/curl/#object-snapshots)

## Fetch snapshots

[Doc](https://app.lokalise.com/api2docs/curl/#transition-list-all-snapshots-get)

```elixir
@client.snapshots(project_id, params = {})  # Input:
                                            ## project_id (string, required)
                                            ## params (hash)
                                            ### :filter_title (string) - set title filter for the list
                                            ### :page and :limit
                                            # Output:
                                            ## Collection of project snapshots
```

## Create snapshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-create-a-snapshot-post)

```elixir
@client.create_snapshot(project_id, params = {})  # Input:
                                                  ## project_id (string, required)
                                                  ## params (hash)
                                                  ### :title (string)
                                                  # Output:
                                                  ## Created snapshot
```

## Restore snapshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-restore-a-snapshot-post)

```elixir
@client.restore_snapshot(project_id, snapshot_id)   # Input:
                                                    ## project_id (string, required)
                                                    ## snapshot_id (string, required)
                                                    # Output:
                                                    ## Information about the restored project from the specified snapshot
```

Alternatively:

```elixir
snapshot = @client.snapshots('project_id').first # you can't fetch a single snapshot
snapshot.restore
```

## Delete snapshot

[Doc](https://app.lokalise.com/api2docs/curl/#transition-delete-a-snapshot-delete)

```elixir
@client.destroy_snapshot(project_id, snapshot_id)   # Input:
                                                    ## project_id (string, required)
                                                    ## snapshot_id (string, required)
                                                    # Output:
                                                    ## Hash with the project id and "snapshot_deleted" set to "true"
```

Alternatively:

```elixir
snapshot = @client.snapshots('project_id').first # you can't fetch a single snapshot
snapshot.destroy
```
