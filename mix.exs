defmodule ElixirLokaliseApi.MixProject do
  use Mix.Project

  @source_url "https://github.com/lokalise/elixir-lokalise-api"
  @version "4.1.1"

  def project do
    [
      app: :elixir_lokalise_api,
      version: @version,
      elixir: "~> 1.14",
      name: "ElixirLokaliseApi",
      package: package(),
      docs: docs(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],

      # Dialyxir
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [:mint]
      ]
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirLokaliseApi.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:finch, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.37", only: [:dev, :test]},
      {:excoveralls, "~> 0.18.1", only: :test},
      {:mox, "~> 1.0", only: :test},
      {:quokka, "~> 2.12", only: [:dev, :test], runtime: false}
    ]
  end

  def docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      homepage_url: @source_url,
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "Lokalise APIv2 interface for Elixir.",
      maintainers: ["Ilya Krukowski"],
      licenses: ["BSD-3-Clause"],
      links: %{
        "Changelog" => "https://lokalise.github.io/elixir-lokalise-api/additional_info/changelog",
        "GitHub" => @source_url
      }
    ]
  end
end
