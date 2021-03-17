defmodule ElixirLokaliseApi.Pagination do
  @moduledoc """
  Provides methods to work with paginated collections.

  Usually resources collections returned by the API are paginated, therefore
  use these methods to work with pagination data.
  """

  @doc """
  Checks whether the returned page is the first one.
  """
  def first_page?(collection), do: not prev_page?(collection)

  @doc """
  Checks whether the returned page is the last one.
  """
  def last_page?(collection), do: not next_page?(collection)

  @doc """
  Checks whether the next page is available.
  """
  def next_page?(collection) do
    collection.current_page > 0 and collection.current_page < collection.page_count
  end

  @doc """
  Checks whether the previous page is available.
  """
  def prev_page?(collection) do
    collection.current_page > 1
  end

  @doc false
  def next_page(collection) do
    case last_page?(collection) do
      true ->
        nil

      false ->
        collection.current_page + 1
    end
  end

  @doc false
  def prev_page(collection) do
    case first_page?(collection) do
      true ->
        nil

      false ->
        collection.current_page - 1
    end
  end
end
