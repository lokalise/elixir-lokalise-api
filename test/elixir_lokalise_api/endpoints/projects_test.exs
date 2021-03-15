defmodule ElixirLokaliseApi.ProjectsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Pagination
  alias ElixirLokaliseApi.Projects
  alias ElixirLokaliseApi.Model.Project, as: ProjectModel
  alias ElixirLokaliseApi.Collection.Projects, as: ProjectsCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Projects

  test "lists all projects" do
    use_cassette "projects_all" do
      {:ok, %ProjectsCollection{} = projects} = Projects.all()
      project = projects.items |> List.first()
      assert project.name == "Branching"

      assert Enum.count(projects.items) == 40
      assert projects.total_count == 40
      assert projects.page_count == 1
      assert projects.per_page_limit == 100
      assert projects.current_page == 1

      assert projects |> Pagination.first_page?()
      assert projects |> Pagination.last_page?()
      refute projects |> Pagination.next_page?()
      refute projects |> Pagination.prev_page?()
      refute projects |> Pagination.next_page()
      refute projects |> Pagination.prev_page()
    end
  end

  test "lists paginated projects" do
    use_cassette "projects_all_paginated" do
      {:ok, %ProjectsCollection{} = projects} = Projects.all(page: 3, limit: 2)
      project = projects.items |> List.first()
      assert project.name == "Demo"

      assert Enum.count(projects.items) == 2
      assert projects.total_count == 40
      assert projects.page_count == 20
      assert projects.per_page_limit == 2
      assert projects.current_page == 3

      refute projects |> Pagination.first_page?()
      refute projects |> Pagination.last_page?()
      assert projects |> Pagination.next_page?()
      assert projects |> Pagination.prev_page?()
      assert projects |> Pagination.next_page() == 4
      assert projects |> Pagination.prev_page() == 2
    end
  end

  test "finds a project" do
    use_cassette "project_find" do
      project_id = "771432525f9836bbd50459.22958598"
      {:ok, %ProjectModel{} = project} = Projects.find(project_id)

      assert project.project_id == project_id
      assert project.project_type == "localization_files"
      assert project.name == "OnBoarding"
      assert project.description == "Lokalise onboarding course"
      assert project.created_at == "2020-10-27 15:03:23 (Etc/UTC)"
      assert project.created_at_timestamp == 1_603_811_003
      assert project.created_by == 20181
      assert project.created_by_email == "bodrovis@protonmail.com"
      assert project.team_id == 176_692
      assert project.base_language_id == 640
      assert project.base_language_iso == "en"
      refute project.settings["per_platform_key_names"]
      assert project.settings.reviewing
      assert project.statistics.progress_total == 28
    end
  end

  test "creates a project" do
    use_cassette "project_create" do
      project_data = %{name: "Elixir SDK", description: "Created via API"}
      {:ok, %ProjectModel{} = project} = Projects.create(project_data)
      assert project.name == "Elixir SDK"
      assert project.description == "Created via API"
    end
  end

  test "updates a project" do
    use_cassette "project_update" do
      project_id = "4943030060101f3d1c6ef9.47027075"
      project_data = %{name: "Updated SDK", description: "Updated via API"}

      {:ok, %ProjectModel{} = project} = Projects.update(project_id, project_data)
      assert project.project_id == project_id
      assert project.name == "Updated SDK"
      assert project.description == "Updated via API"
    end
  end

  test "empties a project" do
    use_cassette "project_empty" do
      project_id = "4943030060101f3d1c6ef9.47027075"
      {:ok, %{} = resp} = Projects.empty(project_id)
      assert resp.keys_deleted
      assert resp.project_id == project_id
    end
  end

  test "deletes a project" do
    use_cassette "project_delete" do
      project_id = "529344536040f3e6a18957.70227936"
      {:ok, %{} = resp} = Projects.delete(project_id)
      assert resp.project_deleted
      assert resp.project_id == project_id
    end
  end

  test "handles error" do
    use_cassette "project_create_error" do
      project_data = %{name: "Elixir SDK", description: "Created via API"}

      {:error, %{} = data, status} = Projects.create(project_data)
      assert status == 400
      assert data.error.message == "Invalid `X-Api-Token` header"
    end
  end
end
