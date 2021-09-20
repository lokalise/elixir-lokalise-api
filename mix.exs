defmodule ElixirLokaliseApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_lokalise_api,
      version: "2.0.0",
      elixir: "~> 1.10",
      name: "ElixirLokaliseApi",
      description: "Lokalise APIv2 interface for Elixir.",
      source_url: "https://github.com/lokalise/elixir-lokalise-api",
      homepage_url: "https://lokalise.github.io/elixir-lokalise-api",
      package: package(),
      docs: docs(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8.0"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.25.2", only: [:dev, :test]},
      {:exvcr, "~> 0.13.2", only: :test},
      {:excoveralls, "~> 0.14.2", only: :test}
    ]
  end

  def docs do
    [
      readme: "README.md",
      main: ElixirLokaliseApi
    ]
  end

  defp package do
    [
      maintainers: ["Ilya Bodrov-Krukowski"],
      licenses: ["BSD-3-Clause"],
      links: %{
        "Github" => "https://github.com/lokalise/elixir-lokalise-api"
      }
    ]
  end
end
