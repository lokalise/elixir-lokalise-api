defmodule ElixirLokaliseApi.Model.PermissionTemplate do
  @moduledoc false
  defstruct id: nil,
            role: nil,
            permissions: [],
            description: nil,
            tag: nil,
            tagColor: nil,
            tagInfo: nil,
            doesEnableAllReadOnlyLanguages: nil
end
