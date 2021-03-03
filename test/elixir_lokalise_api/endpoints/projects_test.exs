defmodule ElixirLokaliseApi.ProjectsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  doctest ElixirLokaliseApi.Projects

  test "lists all projects" do
    use_cassette "projects_all" do
      {:ok, data} = ElixirLokaliseApi.Projects.all
      project = data.projects |> List.first()
      assert Enum.count(data.projects) == 40
      assert project.name == "Branching"
    end
  end

  test "finds a project" do
    use_cassette "project_find" do
      project_id = "771432525f9836bbd50459.22958598"
      {:ok, project} = ElixirLokaliseApi.Projects.find(project_id)
      assert project.project_id == project_id
      assert project.project_type == "localization_files"
      assert project.name == "OnBoarding"
      assert project.description == "Lokalise onboarding course"
      assert project.created_at == "2020-10-27 15:03:23 (Etc/UTC)"
      assert project.created_at_timestamp == 1603811003
      assert project.created_by == 20181
      assert project.created_by_email =="bodrovis@protonmail.com"
      assert project.team_id == 176692
      assert project.base_language_id == 640
      assert project.base_language_iso == "en"
      refute project.settings["per_platform_key_names"]
      assert project.settings.reviewing
      assert project.statistics.progress_total == 28
    end
  end
end
