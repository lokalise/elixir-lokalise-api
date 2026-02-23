defmodule ElixirLokaliseApi.OAuth2.AuthTest do
  use ElixirLokaliseApi.Case, async: false

  alias ElixirLokaliseApi.OAuth2.Auth
  alias ElixirLokaliseApi.Model.OAuth2.Token, as: TokenModel
  alias ElixirLokaliseApi.Projects
  alias ElixirLokaliseApi.Collection.Projects, as: ProjectsCollection

  doctest Auth

  test "auth allows to pass a single scope" do
    uri = Auth.auth(["read_projects"])

    assert String.contains?(uri, "scope=read_projects")
    assert String.contains?(uri, "client_id=fakeoauth2clientid")
    assert String.contains?(uri, "https://app.lokalise.com/oauth2/auth")
  end

  test "auth allows to pass a list of scopes" do
    uri = Auth.auth(["read_projects", "write_projects", "write_tasks"])

    assert String.contains?(uri, "scope=read_projects+write_projects+write_tasks")
    assert String.contains?(uri, "client_id=fakeoauth2clientid")
  end

  test "auth allows to pass redirect uri" do
    uri =
      Auth.auth(
        ["read_projects", "write_tasks"],
        "http://example.com/callback"
      )

    assert String.contains?(uri, "scope=read_projects+write_tasks")
    assert String.contains?(uri, "example.com%2Fcallback")
  end

  test "auth allows to pass state" do
    uri =
      Auth.auth(
        ["read_projects", "write_tasks"],
        "http://example.com/callback",
        "secret state"
      )

    assert String.contains?(uri, "secret+state")
  end

  test "requests token" do
    response = %{
      access_token: "fake_access_token_abcdef123456",
      refresh_token: "fake_refresh_token_123456",
      expires_in: 3600,
      token_type: "Bearer"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      assert(req.method == "POST")
      assert(req.host == "app.lokalise.com")
      assert(req.path == "/oauth2/token")

      response |> ok()
    end)

    {:ok, %TokenModel{} = result} = Auth.token("OAuth2Code")

    assert result.access_token == "fake_access_token_abcdef123456"
    assert result.refresh_token == "fake_refresh_token_123456"
    assert result.expires_in == 3600
    assert result.token_type == "Bearer"
  end

  test "allows to perform request with an access token" do
    :oauth2_token |> ElixirLokaliseApi.Config.put_env("OAuth2Token")

    projects =
      Enum.map(1..2, fn i ->
        %{
          project_id: "pid#{i}",
          name: if(i == 1, do: "First proj", else: "Project #{i}")
        }
      end)

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects")

      %{
        projects: projects
      }
      |> ok([
        {"x-pagination-total-count", "40"},
        {"x-pagination-page-count", "20"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "3"}
      ])
    end)

    {:ok, %ProjectsCollection{} = projects} = Projects.all(page: 3, limit: 2)
    project = projects.items |> hd
    assert project.name == "First proj"

    :oauth2_token |> ElixirLokaliseApi.Config.put_env(nil)
  end

  test "refreshes token" do
    response = %{
      access_token: "fake_access_token_1234567890",
      expires_in: 3600,
      scope: "write_tasks read_projects",
      token_type: "Bearer"
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      assert(req.method == "POST")
      assert(req.host == "app.lokalise.com")
      assert(req.path == "/oauth2/token")

      response |> ok()
    end)

    {:ok, %TokenModel{} = result} = Auth.refresh("OAuth2RefreshToken")

    assert result.access_token == "fake_access_token_1234567890"
    assert result.expires_in == 3600
    assert result.token_type == "Bearer"
    assert result.scope == "write_tasks read_projects"
  end
end
