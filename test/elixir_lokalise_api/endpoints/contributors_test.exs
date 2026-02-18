defmodule ElixirLokaliseApi.ContributorsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Contributors
  alias ElixirLokaliseApi.Model.Contributor, as: ContributorModel
  alias ElixirLokaliseApi.Collection.Contributors, as: ContributorsCollection

  doctest Contributors

  @project_id "217830385f9c0fdbd589f0.91420183"

  test "lists all contributors" do
    contributors =
      for i <- 1..3 do
        %{
          user_id: 20_000 + i,
          email: "user#{i}@example.com",
          fullname: "User #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      contributors: contributors
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/contributors")

      response
      |> ok()
    end)

    {:ok, %ContributorsCollection{} = contributors} = Contributors.all(@project_id)

    assert Enum.count(contributors.items) == 3
    assert contributors.project_id == @project_id

    contributor = hd(contributors.items)
    assert contributor.user_id == 20_001
  end

  test "lists paginated contributors" do
    response = %{
      project_id: @project_id,
      contributors: [
        %{
          user_id: 20_000,
          email: "user1@example.com",
          fullname: "User 1"
        }
      ]
    }

    params = [page: 2, limit: 1]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/contributors")

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

    {:ok, %ContributorsCollection{} = contributors} =
      Contributors.all(@project_id, params)

    assert Enum.count(contributors.items) == 1
    assert contributors.project_id == @project_id
    assert contributors.total_count == 3
    assert contributors.page_count == 3
    assert contributors.per_page_limit == 1
    assert contributors.current_page == 2

    refute contributors |> Pagination.first_page?()
    refute contributors |> Pagination.last_page?()
    assert contributors |> Pagination.next_page?()
    assert contributors |> Pagination.prev_page?()

    contributor = contributors.items |> List.first()
    assert contributor.user_id == 20_000
  end

  test "finds a contributor" do
    user_id = 72008

    contributor_response = %{
      project_id: @project_id,
      contributor: %{
        user_id: user_id,
        email: "user@example.com",
        fullname: "Test User",
        created_at: "2024-01-01 00:00:00 (Etc/UTC)",
        created_at_timestamp: 1_700_000_000,
        is_admin: false,
        is_reviewer: true,
        languages: [
          %{
            lang_id: 1,
            lang_iso: "en",
            lang_name: "English",
            is_writable: false
          },
          %{
            lang_id: 2,
            lang_iso: "de",
            lang_name: "German",
            is_writable: true
          }
        ],
        admin_rights: [],
        role_id: 5
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/contributors/#{user_id}")

      contributor_response
      |> ok()
    end)

    {:ok, %ContributorModel{} = contributor} = Contributors.find(@project_id, 72008)

    assert contributor.user_id == user_id
    assert contributor.email == "user@example.com"
    assert contributor.fullname == "Test User"
    assert contributor.created_at == "2024-01-01 00:00:00 (Etc/UTC)"
    assert contributor.created_at_timestamp == 1_700_000_000
    refute contributor.is_admin
    assert contributor.is_reviewer
    refute List.first(contributor.languages).is_writable
    assert contributor.admin_rights == []
    assert contributor.role_id == 5
  end

  test "finds a me (current contributor)" do
    contributor_response = %{
      project_id: @project_id,
      contributor: %{
        user_id: 123,
        email: "user@example.com",
        fullname: "Test User"
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/contributors/me")

      contributor_response
      |> ok()
    end)

    {:ok, %ContributorModel{} = contributor} =
      Contributors.me(@project_id)

    assert contributor.fullname == "Test User"
  end

  test "creates a contributor" do
    data = %{
      contributors: [
        %{
          email: "elixir_test@example.com",
          fullname: "Elixir Rocks",
          languages: [
            %{
              lang_iso: "en",
              is_writable: false
            }
          ]
        }
      ]
    }

    contributor_response = %{
      project_id: @project_id,
      contributors: [
        %{
          user_id: 123,
          email: "elixir_test@example.com",
          fullname: "Elixir Rocks",
          languages: [
            %{
              lang_id: 1,
              lang_iso: "en",
              lang_name: "English",
              is_writable: false
            }
          ]
        }
      ]
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/contributors", "POST")

      req |> assert_json_body(data)

      contributor_response |> ok()
    end)

    {:ok, %ContributorsCollection{} = contributors} = Contributors.create(@project_id, data)

    assert contributors.project_id == @project_id

    contributor = hd(contributors.items)

    assert contributor.email == "elixir_test@example.com"
    assert contributor.fullname == "Elixir Rocks"
    assert List.first(contributor.languages).lang_iso == "en"
  end

  test "updates a contributor" do
    user_id = 123

    data = %{
      is_reviewer: true
    }

    contributor_response = %{
      project_id: @project_id,
      contributor: %{
        user_id: user_id,
        email: "elixir_test@example.com",
        fullname: "Elixir Rocks",
        is_reviewer: true
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/contributors/#{user_id}", "PUT")

      req |> assert_json_body(data)

      contributor_response |> ok()
    end)

    {:ok, %ContributorModel{} = contributor} = Contributors.update(@project_id, user_id, data)

    assert contributor.user_id == user_id
    assert contributor.is_reviewer
  end

  test "deletes a contributor" do
    user_id = 97280

    resp = %{
      project_id: @project_id,
      contributor_deleted: true
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/contributors/#{user_id}", "DELETE")

      resp |> ok()
    end)

    {:ok, %{} = resp} = Contributors.delete(@project_id, user_id)

    assert resp.contributor_deleted
    assert resp.project_id == @project_id
  end
end
