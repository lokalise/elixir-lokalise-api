defmodule ElixirLokaliseApi.ProjectCommentsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.ProjectComments
  alias ElixirLokaliseApi.Collection.Comments, as: CommentCollection

  setup_all do
    HTTPoison.start()
  end

  doctest ProjectComments

  test "lists all project comments" do
    use_cassette "project_comments_all" do
      project_id = "217830385f9c0fdbd589f0.91420183"
      {:ok, %CommentCollection{} = comments} = ProjectComments.all(project_id)

      assert Enum.count(comments.items) == 3
      assert comments.total_count == 3
      assert comments.page_count == 1
      assert comments.per_page_limit == 100
      assert comments.current_page == 1
      assert comments.project_id == project_id

      comment = comments.items |> List.first()
      assert comment.comment == "sample"
    end
  end

  test "lists paginated project comment" do
    use_cassette "project_comments_all_paginated" do
      project_id = "217830385f9c0fdbd589f0.91420183"
      {:ok, %CommentCollection{} = comments} = ProjectComments.all(project_id, page: 2, limit: 1)

      assert Enum.count(comments.items) == 1
      assert comments.total_count == 3
      assert comments.page_count == 3
      assert comments.per_page_limit == 1
      assert comments.current_page == 2
      assert comments.project_id == project_id

      refute comments |> Pagination.first_page?()
      refute comments |> Pagination.last_page?()
      assert comments |> Pagination.next_page?()
      assert comments |> Pagination.prev_page?()

      comment = hd(comments.items)
      assert comment.comment == "my comment"
    end
  end
end
