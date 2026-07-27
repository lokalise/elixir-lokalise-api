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
      :has_more,
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

  test "parses pagination data from headers and response body" do
    headers = [
      {"X-Pagination-Total-Count", "abc"},
      {"x-pagination-page-count", "10"}
    ]

    body =
      Jason.encode!(%{
        items: [%{id: 1}],
        has_more: true,
        next_cursor: "next-cursor-value"
      })

    resp = %Finch.Response{
      status: 200,
      headers: headers,
      body: body
    }

    {:ok, %DummyCollection{} = collection} =
      Processor.parse(resp, DummyModule, nil)

    assert [%DummyModel{id: 1}] = collection.items

    assert collection.total_count == "abc"
    assert collection.page_count == 10

    assert collection.has_more
    assert collection.next_cursor == "next-cursor-value"
  end
end
