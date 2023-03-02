defmodule ElixirLokaliseApi.OAuth2.AuthTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ElixirLokaliseApi.OAuth2.Auth
  alias ElixirLokaliseApi.Config
  alias ElixirLokaliseApi.Model.OAuth2.Token, as: TokenModel
  alias ElixirLokaliseApi.Projects
  alias ElixirLokaliseApi.Collection.Projects, as: ProjectsCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Auth

  test "auth allows to pass a single scope" do
    uri = Auth.auth(["read_projects"])

    assert String.contains?(uri, "scope=read_projects")
    assert String.contains?(uri, "client_id=#{Config.oauth2_client_id()}")
    assert String.contains?(uri, "https://app.lokalise.com/oauth2/auth")
  end

  test "auth allows to pass a list of scopes" do
    uri = Auth.auth(["read_projects", "write_projects", "write_tasks"])

    assert String.contains?(uri, "scope=read_projects+write_projects+write_tasks")
    assert String.contains?(uri, "client_id=#{Config.oauth2_client_id()}")
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
    use_cassette "oauth2_token" do
      {:ok, %TokenModel{} = result} = Auth.token(System.get_env("OAUTH2_CODE"))

      assert result.access_token == "e43a0fac0e025da1dbbf7201a08c28691f399a1d"
      assert result.refresh_token == "123"
      assert result.expires_in == 3600
      assert result.token_type == "Bearer"
    end
  end

  test "allows to perform request with an access token" do
    :oauth2_token |> ElixirLokaliseApi.Config.put_env(System.get_env("OAUTH2_ACCESS_TOKEN"))

    use_cassette "oauth2_projects" do
      {:ok, %ProjectsCollection{} = projects} = Projects.all(page: 3, limit: 2)
      project = projects.items |> hd
      assert project.name == "Automations"
    end

    :oauth2_token |> ElixirLokaliseApi.Config.put_env(nil)
  end

  test "refreshes token" do
    use_cassette "oauth2_refresh" do
      {:ok, %TokenModel{} = result} = Auth.refresh(System.get_env("OAUTH2_REFRESH_TOKEN"))

      assert result.access_token != nil
      assert result.expires_in == 3600
      assert result.token_type == "Bearer"
      assert result.scope == "write_tasks read_projects"
    end
  end
end
