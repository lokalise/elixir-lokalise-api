defmodule ElixirLokaliseApi.V1.AuditLogsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.V1.AuditLogs, as: AuditLogsCollection
  alias ElixirLokaliseApi.CursorPagination
  alias ElixirLokaliseApi.Model.V1.AuditLog, as: AuditLogModel
  alias ElixirLokaliseApi.V1.AuditLogs

  doctest AuditLogs

  test "lists audit logs with cursor pagination" do
    logs = [
      %{
        class_uid: 6003,
        class_name: "API Activity",
        category_uid: 6,
        category_name: "Application Activity",
        activity_id: 99,
        activity_name: "Other",
        type_uid: 600_399,
        severity_id: 1,
        severity: "Informational",
        status_id: 1,
        status: "Success",
        time: 1_753_267_304,
        metadata: %{
          event_code: "project.deleted"
        }
      },
      %{
        class_uid: 6004,
        class_name: "API Activity",
        category_uid: 6,
        category_name: "Application Activity",
        activity_id: 99,
        activity_name: "Other",
        type_uid: 600_400,
        severity_id: 1,
        severity: "Informational",
        status_id: 1,
        status: "Success",
        time: 1_753_267_305,
        metadata: %{
          event_code: "project.created"
        }
      }
    ]

    response = %{
      data: logs,
      has_more: true,
      next_cursor: "200"
    }

    params = [limit: 2, cursor: "100"]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/v1/audit-logs")

      req
      |> assert_get_params(params)

      response
      |> ok([])
    end)

    {:ok, %AuditLogsCollection{} = audit_logs} =
      AuditLogs.all(params)

    assert Enum.count(audit_logs.items) == 2
    assert audit_logs.has_more
    assert audit_logs.next_cursor == "200"

    assert CursorPagination.has_more?(audit_logs)
    assert CursorPagination.next_cursor?(audit_logs)
    refute CursorPagination.last_page?(audit_logs)
    assert CursorPagination.next_cursor(audit_logs) == "200"

    audit_log = hd(audit_logs.items)

    assert %AuditLogModel{} = audit_log
    assert audit_log.class_uid == 6003
    assert audit_log.class_name == "API Activity"
    assert audit_log.category_uid == 6
    assert audit_log.activity_name == "Other"
    assert audit_log.severity == "Informational"
    assert audit_log.status == "Success"
    assert audit_log.metadata.event_code == "project.deleted"
  end
end
