defmodule ElixirLokaliseApi.Model.V1.AuditLog do
  @moduledoc false

  defstruct class_uid: nil,
            class_name: nil,
            category_uid: nil,
            category_name: nil,
            activity_id: nil,
            activity_name: nil,
            type_uid: nil,
            type_name: nil,
            severity_id: nil,
            severity: nil,
            status_id: nil,
            status: nil,
            time: nil,
            metadata: %{},
            actor: %{},
            src_endpoint: %{},
            http_request: %{},
            enrichments: [],
            unmapped: %{}
end
