defmodule ElixirLokaliseApi.Collection.PaymentCards do
  @moduledoc false
  defstruct items: [],
            total_count: nil,
            page_count: nil,
            per_page_limit: nil,
            current_page: nil,
            user_id: nil
end
