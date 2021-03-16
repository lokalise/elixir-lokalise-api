defmodule ElixirLokaliseApi.Pagination do
  def first_page?(collection) do
    not prev_page?(collection)
  end

  def last_page?(collection) do
    not next_page?(collection)
  end

  def next_page?(collection) do
    collection.current_page > 0 and collection.current_page < collection.page_count
  end

  def prev_page?(collection) do
    collection.current_page > 1
  end

  def next_page(collection) do
    case last_page?(collection) do
      true ->
        nil

      false ->
        collection.current_page + 1
    end
  end

  def prev_page(collection) do
    case first_page?(collection) do
      true ->
        nil

      false ->
        collection.current_page - 1
    end
  end
end
