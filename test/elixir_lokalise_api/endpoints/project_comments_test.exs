defmodule ElixirLokaliseApi.ProjectCommentsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.ProjectComments
  alias ElixirLokaliseApi.Collection.Comments, as: CommentCollection

  doctest ProjectComments

  @project_id "217830385f9c0fdbd589f0.91420183"

  test "lists all project comments" do
    response = %{
      project_id: @project_id,
      comments: [
        %{
          comment_id: 8_674_081,
          key_id: 63_087_986,
          comment: "sample",
          added_by: 20_181,
          added_by_email: "user@example.com",
          added_at: "2021-03-08 15:02:47 (Etc/UTC)",
          added_at_timestamp: 1_615_215_767
        },
        %{
          comment_id: 8_674_082,
          key_id: 62_742_930,
          comment: "my comment",
          added_by: 20_181,
          added_by_email: "user@example.com",
          added_at: "2021-03-08 15:02:53 (Etc/UTC)",
          added_at_timestamp: 1_615_215_773
        },
        %{
          comment_id: 8_674_083,
          key_id: 62_742_923,
          comment: "That's a comment!",
          added_by: 20_181,
          added_by_email: "user@example.com",
          added_at: "2021-03-08 15:03:01 (Etc/UTC)",
          added_at_timestamp: 1_615_215_781
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/comments")

      response
      |> ok([
        {"x-pagination-total-count", "3"},
        {"x-pagination-page-count", "1"},
        {"x-pagination-limit", "100"},
        {"x-pagination-page", "1"}
      ])
    end)

    {:ok, %CommentCollection{} = comments} = ProjectComments.all(@project_id)

    assert Enum.count(comments.items) == 3
    assert comments.total_count == 3
    assert comments.page_count == 1
    assert comments.per_page_limit == 100
    assert comments.current_page == 1
    assert comments.project_id == @project_id

    comment = comments.items |> hd()
    assert comment.comment == "sample"
  end

  test "lists paginated project comment" do
    response = %{
      project_id: @project_id,
      comments: [
        %{
          comment_id: 8_674_082,
          key_id: 62_742_930,
          comment: "my comment",
          added_by: 20_181,
          added_by_email: "user@example.com",
          added_at: "2021-03-08 15:02:53 (Etc/UTC)",
          added_at_timestamp: 1_615_215_773
        }
      ]
    }

    params = [page: 2, limit: 1]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/comments")

      req
      |> assert_get_params(params)

      response
      |> ok([
        {"x-pagination-total-count", "3"},
        {"x-pagination-page-count", "3"},
        {"x-pagination-limit", "1"},
        {"x-pagination-page", "2"}
      ])
    end)

    {:ok, %CommentCollection{} = comments} = ProjectComments.all(@project_id, params)

    assert Enum.count(comments.items) == 1
    assert comments.total_count == 3
    assert comments.page_count == 3
    assert comments.per_page_limit == 1
    assert comments.current_page == 2
    assert comments.project_id == @project_id

    refute comments |> Pagination.first_page?()
    refute comments |> Pagination.last_page?()
    assert comments |> Pagination.next_page?()
    assert comments |> Pagination.prev_page?()

    comment = hd(comments.items)
    assert comment.comment == "my comment"
  end
end
