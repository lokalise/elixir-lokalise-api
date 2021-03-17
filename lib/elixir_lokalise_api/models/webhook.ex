defmodule ElixirLokaliseApi.Model.Webhook do
  @moduledoc false
  defstruct webhook_id: nil,
            url: nil,
            branch: nil,
            secret: nil,
            events: [],
            event_lang_map: %{}
end
