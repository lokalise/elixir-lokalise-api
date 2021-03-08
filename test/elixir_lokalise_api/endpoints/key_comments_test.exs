defmodule ElixirLokaliseApi.KeyCommentsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.KeyComments
  alias ElixirLokaliseApi.Collection.Comments, as: CommentCollection
  alias ElixirLokaliseApi.Model.Comment, as: CommentModel

  setup_all do
    HTTPoison.start
  end

  doctest KeyComments

  @project_id "217830385f9c0fdbd589f0.91420183"
  @key_id 63087986

  test "lists all key comments" do
    use_cassette "key_comments_all" do
      {:ok, %CommentCollection{} = comments} = KeyComments.all @project_id, @key_id

      assert Enum.count(comments.items) == 3
      assert comments.total_count == 3
      assert comments.page_count == 1
      assert comments.per_page_limit == 100
      assert comments.current_page == 1
      assert comments.project_id == @project_id

      comment = comments.items |> List.first()
      assert comment.comment == "sample"
    end
  end

  test "lists paginated all key comments" do
    use_cassette "key_comments_all_paginated" do
      {:ok, %CommentCollection{} = comments} = KeyComments.all @project_id, @key_id, limit: 1, page: 2

      assert Enum.count(comments.items) == 1
      assert comments.total_count == 3
      assert comments.page_count == 3
      assert comments.per_page_limit == 1
      assert comments.current_page == 2
      assert comments.project_id == @project_id

      refute comments |> Pagination.first_page?
      refute comments |> Pagination.last_page?
      assert comments |> Pagination.next_page?
      assert comments |> Pagination.prev_page?

      comment = comments.items |> List.first()
      assert comment.comment == "Image file key"
    end
  end

  test "finds a key comment" do
    use_cassette "key_comment_find" do
      comment_id = 8674087
      {:ok, %CommentModel{} = comment} = KeyComments.find @project_id, @key_id, comment_id

      assert comment.comment == "Image file key"
      assert comment.comment_id == comment_id
      assert comment.key_id == @key_id
      assert comment.added_by == 20181
      assert comment.added_by_email == "bodrovis@protonmail.com"
      assert comment.added_at == "2021-03-08 15:09:46 (Etc/UTC)"
      assert comment.added_at_timestamp == 1615216186
    end
  end

  test "creates a key comment" do
    use_cassette "key_comment_create" do
      data = %{comments: [
        %{ comment: "Elixir comment" }
      ]}
      {:ok, %CommentCollection{} = comments} = KeyComments.create @project_id, @key_id, data

      assert Enum.count(comments.items) == 1
      assert comments.project_id == @project_id

      comment = comments.items |> List.first()
      assert comment.comment == "Elixir comment"
      assert comment.key_id == @key_id
    end
  end

  test "deletes a key comment" do
    use_cassette "key_comment_delete" do
      {:ok, %{} = resp} = KeyComments.delete @project_id, @key_id, 8674101

      assert resp.project_id == @project_id
      assert resp.comment_deleted
    end
  end
end
