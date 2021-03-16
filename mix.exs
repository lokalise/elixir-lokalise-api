defmodule ElixirLokaliseApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_lokalise_api,
      version: "0.1.0",
      elixir: "~> 1.2",
      name: "ElixirLokaliseApi",
      description: "Lokalise APIv2 interface for Elixir.",
      source_url: "https://github.com/bodrovis/elixir-lokalise-api",
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
      {:httpoison, ">= 0.9.0"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.23", only: [:dev, :test]},
      {:exvcr, "~> 0.11", only: :test},
      {:excoveralls, "~> 0.13", only: :test}
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
        "Github" => "https://github.com/bodrovis/elixir-lokalise-api"
      }
    ]
  end
end
