defmodule ElixirLokaliseApi.CursorPagination do
  @moduledoc """
  Provides helper functions for cursor-paginated collections.
  """

  @doc """
  Checks whether more items are available.
  """
  def has_more?(collection), do: collection.has_more == true

  @doc """
  Checks whether another cursor is available.
  """
  def next_cursor?(collection) do
    has_more?(collection) and
      is_binary(collection.next_cursor) and
      byte_size(collection.next_cursor) > 0
  end

  @doc """
  Checks whether the current collection is the last one.
  """
  def last_page?(collection), do: not has_more?(collection)

  @doc """
  Returns the next cursor or nil when no more items are available.
  """
  def next_cursor(collection) do
    if next_cursor?(collection) do
      collection.next_cursor
    end
  end
end
