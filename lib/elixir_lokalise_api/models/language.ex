defmodule ElixirLokaliseApi.Model.Language do
  @moduledoc false
  defstruct lang_id: nil,
            lang_iso: nil,
            lang_name: nil,
            is_rtl: nil,
            plural_forms: []
end
