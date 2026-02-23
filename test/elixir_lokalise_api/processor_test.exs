defmodule ElixirLokaliseApi.ProcessorTest do
  use ExUnit.Case, async: true

  alias ElixirLokaliseApi.Processor

  defmodule DummyModel do
    defstruct [:id]
  end

  defmodule DummyCollection do
    defstruct [
      :items,
      :total_count,
      :page_count,
      :per_page_limit,
      :current_page,
      :next_cursor
    ]
  end

  defmodule DummyModule do
    def data_key, do: :items
    def singular_data_key, do: :item

    def model, do: DummyModel
    def collection, do: DummyCollection

    def parent_key, do: nil
  end

  test "pagination_for keeps non-numeric pagination header values as strings" do
    headers = [
      {"X-Pagination-Total-Count", "abc"},
      {"x-pagination-page-count", "10"}
    ]

    body =
      Jason.encode!(%{
        items: [%{id: 1}]
      })

    resp = %Finch.Response{
      status: 200,
      headers: headers,
      body: body
    }

    {:ok, %DummyCollection{} = col} = Processor.parse(resp, DummyModule, nil)

    assert col.total_count == "abc"
    assert col.page_count == 10
  end
end
