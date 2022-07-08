defmodule DocumentationExtractor.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :documentation_extractor,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Documentation extractor",
      source_url: "https://github.com/GabrielFeliciano/documentation_extractor"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "A package for extracting documentation from modules and their functions"
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/GabrielFeliciano/documentation_extractor"}
    ]
  end
end
