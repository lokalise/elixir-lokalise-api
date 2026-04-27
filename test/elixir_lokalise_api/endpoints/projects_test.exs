defmodule ElixirLokaliseApi.ProjectsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Collection.Projects, as: ProjectsCollection
  alias ElixirLokaliseApi.Model.Project, as: ProjectModel
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Projects

  doctest Projects

  test "lists all projects" do
    projects =
      Enum.map(1..40, fn i ->
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
        {"x-pagination-page-count", "1"},
        {"x-pagination-limit", "100"},
        {"x-pagination-page", "1"}
      ])
    end)

    {:ok, %ProjectsCollection{} = projects_col} = Projects.all()
    project = projects_col.items |> List.first()

    assert project.name == "First proj"

    project2 = projects_col.items |> Enum.at(1)
    assert project2.name == "Project 2"

    assert Enum.count(projects_col.items) == 40
    assert projects_col.total_count == 40
    assert projects_col.page_count == 1
    assert projects_col.per_page_limit == 100
    assert projects_col.current_page == 1

    assert Pagination.first_page?(projects_col)
    assert Pagination.last_page?(projects_col)
    refute Pagination.next_page?(projects_col)
    refute Pagination.prev_page?(projects_col)
    refute Pagination.next_page(projects_col)
    refute Pagination.prev_page(projects_col)
  end

  test "lists paginated projects" do
    params = [page: 3, limit: 2]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects")

      req
      |> assert_get_params(params)

      %{
        projects: [
          %{project_id: "p_demo", name: "Demo"},
          %{project_id: "p_2", name: "Project 2"}
        ]
      }
      |> ok([
        {"x-pagination-total-count", "40"},
        {"x-pagination-page-count", "20"},
        {"x-pagination-limit", "2"},
        {"x-pagination-page", "3"}
      ])
    end)

    {:ok, %ProjectsCollection{} = projects} = Projects.all(params)
    project = projects.items |> hd()

    assert project.name == "Demo"

    assert Enum.count(projects.items) == 2
    assert projects.total_count == 40
    assert projects.page_count == 20
    assert projects.per_page_limit == 2
    assert projects.current_page == 3

    refute Pagination.first_page?(projects)
    refute Pagination.last_page?(projects)
    assert Pagination.next_page?(projects)
    assert Pagination.prev_page?(projects)
    assert Pagination.next_page(projects) == 4
    assert Pagination.prev_page(projects) == 2
  end

  test "finds a project" do
    project_id = "771432525f9836bbd50459.22958598"

    project = %{
      project_id: project_id,
      project_type: "localization_files",
      name: "OnBoarding",
      description: "Lokalise onboarding course",
      created_at: "2020-10-27 15:03:23 (Etc/UTC)",
      created_at_timestamp: 1_603_811_003,
      created_by: 20_181,
      created_by_email: "bodrovis@protonmail.com",
      team_id: 176_692,
      base_language_id: 640,
      base_language_iso: "en",
      settings: %{per_platform_key_names: false, reviewing: true},
      statistics: %{progress_total: 28}
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}")

      project |> ok()
    end)

    {:ok, %ProjectModel{} = project} = Projects.find(project_id)

    assert project.project_id == project_id
    assert project.project_type == "localization_files"
    assert project.name == "OnBoarding"
    assert project.description == "Lokalise onboarding course"
    assert project.created_at == "2020-10-27 15:03:23 (Etc/UTC)"
    assert project.created_at_timestamp == 1_603_811_003
    assert project.created_by == 20_181
    assert project.created_by_email == "bodrovis@protonmail.com"
    assert project.team_id == 176_692
    assert project.base_language_id == 640
    assert project.base_language_iso == "en"
    refute project.settings.per_platform_key_names
    assert project.settings.reviewing
    assert project.statistics.progress_total == 28
  end

  test "creates a project" do
    project_data = %{name: "Elixir SDK", description: "Created via API"}

    project =
      Map.merge(project_data, %{
        project_id: "123.abc",
        project_type: "localization_files",
        created_at: "2020-10-27 15:03:23 (Etc/UTC)",
        created_at_timestamp: 1_603_811_003,
        created_by: 20_181,
        team_id: 176_692,
        base_language_id: 640,
        base_language_iso: "en"
      })

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects", "POST")

      req |> assert_json_body(project_data)

      project |> ok()
    end)

    {:ok, %ProjectModel{} = project} = Projects.create(project_data)
    assert project.name == "Elixir SDK"
    assert project.description == "Created via API"
  end

  test "updates a project" do
    project_id = "4943030060101f3d1c6ef9.47027075"
    project_data = %{name: "Updated SDK", description: "Updated via API"}

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}", "PUT")

      req |> assert_json_body(project_data)

      Map.put(project_data, :project_id, project_id) |> ok()
    end)

    {:ok, %ProjectModel{} = project} = Projects.update(project_id, project_data)
    assert project.project_id == project_id
    assert project.name == "Updated SDK"
    assert project.description == "Updated via API"
  end

  test "empties a project" do
    project_id = "4943030060101f3d1c6ef9.47027075"

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}/empty", "PUT")

      %{project_id: project_id, keys_deleted: true} |> ok()
    end)

    {:ok, %{} = resp} = Projects.empty(project_id)
    assert resp.keys_deleted
    assert resp.project_id == project_id
  end

  test "deletes a project" do
    project_id = "529344536040f3e6a18957.70227936"

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{project_id}", "DELETE")

      %{project_id: project_id, project_deleted: true} |> ok()
    end)

    {:ok, %{} = resp} = Projects.delete(project_id)
    assert resp.project_deleted
    assert resp.project_id == project_id
  end

  test "handles error" do
    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects", "POST")

      400
      |> err(%{
        error: %{
          message: "Invalid `X-Api-Token` header"
        }
      })
    end)

    {:error, {data, status}} =
      Projects.create(%{name: "Elixir SDK", description: "Created via API"})

    assert status == 400
    assert data.error.message == "Invalid `X-Api-Token` header"
  end
end
