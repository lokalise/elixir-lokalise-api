---
---

# Audit logs

## List audit logs

[API doc](https://developers.lokalise.com/reference/list-audit-logs)

The audit logs endpoint uses Lokalise API v1 rather than APIv2.

The API v1 base URL is configured separately with `:base_url_api_v1`. The existing `:base_url_api` option continues to control APIv2 endpoints.

```elixir
config :elixir_lokalise_api,
  base_url_api_v1: "https://api.lokalise.com/v1/"
```

You do not need to set this option unless you want to override the default API v1 URL.

```elixir
alias ElixirLokaliseApi.CursorPagination
alias ElixirLokaliseApi.V1.AuditLogs

{:ok, audit_logs} = AuditLogs.all(limit: 2)

audit_log = audit_logs.items |> List.first()

audit_log.class_uid # => 6003
audit_log.class_name # => "API Activity"
audit_log.metadata.event_code # => "project.deleted"
```

Audit logs use cursor-based pagination. Pagination information is returned in the collection:

```elixir
audit_logs.has_more # => true
audit_logs.next_cursor # => "eyJpZCI6..."
```

You can also use the cursor pagination helpers:

```elixir
CursorPagination.has_more?(audit_logs) # => true
CursorPagination.next_cursor?(audit_logs) # => true
CursorPagination.last_page?(audit_logs) # => false
CursorPagination.next_cursor(audit_logs) # => "eyJpZCI6..."
```

Pass the returned cursor to fetch the next collection:

```elixir
{:ok, next_audit_logs} =
  AuditLogs.all(
    limit: 2,
    cursor: CursorPagination.next_cursor(audit_logs)
  )
```
