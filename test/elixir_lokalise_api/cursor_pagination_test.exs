defmodule ElixirLokaliseApi.CursorPaginationTest do
  use ExUnit.Case, async: true

  alias ElixirLokaliseApi.CursorPagination

  test "next_cursor? returns true when more results and cursor are available" do
    collection = %{has_more: true, next_cursor: "cursor-value"}

    assert CursorPagination.next_cursor?(collection)
  end

  test "next_cursor? returns false when there are no more results" do
    collection = %{has_more: false, next_cursor: "cursor-value"}

    refute CursorPagination.next_cursor?(collection)
  end

  test "next_cursor? returns false when cursor is nil" do
    collection = %{has_more: true, next_cursor: nil}

    refute CursorPagination.next_cursor?(collection)
  end

  test "next_cursor? returns false when cursor is empty" do
    collection = %{has_more: true, next_cursor: ""}

    refute CursorPagination.next_cursor?(collection)
  end
end
