defmodule ElixirLokaliseApi.Endpoint.Project do
  use ElixirLokaliseApi.DynamicResource, import: [:get]

  defstruct project_id: nil
end
