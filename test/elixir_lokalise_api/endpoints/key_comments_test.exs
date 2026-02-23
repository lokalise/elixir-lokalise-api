defmodule ElixirLokaliseApi.KeyCommentsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.KeyComments
  alias ElixirLokaliseApi.Collection.Comments, as: CommentCollection
  alias ElixirLokaliseApi.Model.Comment, as: CommentModel

  doctest KeyComments

  @project_id "217830385f9c0fdbd589f0.91420183"
  @key_id 63_087_986

  test "lists all key comments" do
    comments =
      for i <- 1..3 do
        %{
          comment_id: 20_000 + i,
          key_id: @key_id,
          comment: "Comment #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      comments: comments
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{@key_id}/comments")

      response
      |> ok([
        {"x-pagination-total-count", "3"},
        {"x-pagination-page-count", "1"},
        {"x-pagination-limit", "100"},
        {"x-pagination-page", "1"}
      ])
    end)

    {:ok, %CommentCollection{} = comments} = KeyComments.all(@project_id, @key_id)

    assert Enum.count(comments.items) == 3
    assert comments.total_count == 3
    assert comments.page_count == 1
    assert comments.per_page_limit == 100
    assert comments.current_page == 1
    assert comments.project_id == @project_id

    comment = comments.items |> hd()
    assert comment.comment == "Comment 1"
  end

  test "lists paginated all key comments" do
    comments =
      for i <- 1..2 do
        %{
          comment_id: 20_000 + i,
          key_id: @key_id,
          comment: "Comment #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      comments: comments
    }

    params = [limit: 2, page: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{@key_id}/comments")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "4"},
        {"x-pagination-page-count", "2"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %CommentCollection{} = comments} =
      KeyComments.all(@project_id, @key_id, params)

    assert Enum.count(comments.items) == 2
    assert comments.total_count == 4
    assert comments.page_count == 2
    assert comments.per_page_limit == 2
    assert comments.current_page == 2
    assert comments.project_id == @project_id

    refute comments |> Pagination.first_page?()
    assert comments |> Pagination.last_page?()
    refute comments |> Pagination.next_page?()
    assert comments |> Pagination.prev_page?()

    comment = hd(comments.items)
    assert comment.comment == "Comment 1"
  end

  test "finds a key comment" do
    comment_id = 8_674_087

    response = %{
      project_id: @project_id,
      comment: %{
        comment_id: comment_id,
        key_id: @key_id,
        comment: "Comment 1",
        added_by: 20_181,
        added_by_email: "user@example.com",
        added_at: "2021-03-08 15:09:46 (Etc/UTC)",
        added_at_timestamp: 1_615_216_186
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/keys/#{@key_id}/comments/#{comment_id}"
      )

      response
      |> ok()
    end)

    {:ok, %CommentModel{} = comment} = KeyComments.find(@project_id, @key_id, comment_id)

    assert comment.comment == "Comment 1"
    assert comment.comment_id == comment_id
    assert comment.key_id == @key_id
    assert comment.added_by == 20_181
    assert comment.added_by_email == "user@example.com"
    assert comment.added_at == "2021-03-08 15:09:46 (Etc/UTC)"
    assert comment.added_at_timestamp == 1_615_216_186
  end

  test "creates a key comment" do
    data = %{
      comments: [
        %{comment: "Elixir comment"}
      ]
    }

    response = %{
      project_id: @project_id,
      comments: [
        %{
          comment_id: 123,
          key_id: @key_id,
          comment: "Elixir comment"
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/keys/#{@key_id}/comments",
        "POST"
      )

      req |> assert_json_body(data)

      response
      |> ok()
    end)

    {:ok, %CommentCollection{} = comments} = KeyComments.create(@project_id, @key_id, data)

    assert Enum.count(comments.items) == 1
    assert comments.project_id == @project_id

    comment = hd(comments.items)
    assert comment.comment == "Elixir comment"
    assert comment.key_id == @key_id
  end

  test "deletes a key comment" do
    comment_id = 8_674_101

    response = %{
      project_id: @project_id,
      comment_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/keys/#{@key_id}/comments/#{comment_id}",
        "DELETE"
      )

      response
      |> ok()
    end)

    {:ok, %{} = resp} = KeyComments.delete(@project_id, @key_id, comment_id)

    assert resp.project_id == @project_id
    assert resp.comment_deleted
  end
end
