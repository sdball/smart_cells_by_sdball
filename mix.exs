defmodule SdballSmartcells.MixProject do
  use Mix.Project

  @github "https://github.com/sdball/smart_cells_by_sdball"
  @version "0.0.1"

  def project do
    [
      name: "Smart Cells by sdball",
      description: "A collection of totally awesome Livebook smartcells by sdball",
      app: :smart_cells_by_sdball,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      source_url: @github
    ]
  end

  def application do
    [
      mod: {SmartCellsBySdball.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xkcd, "~> 0.0.3"},
      {:kino, "~> 0.6.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github
      }
    ]
  end

  defp docs do
    [
      main: "components",
      source_url: @github,
      source_ref: "v#{@version}",
      extras: ["guides/components.livemd"]
    ]
  end
end
