defmodule TypeID.MixProject do
  use Mix.Project

  @version "0.5.1"

  def project do
    [
      app: :typeid_elixir,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "TypeID Elixir",
      source_url: "https://github.com/sloanelybutsurely/typeid-elixir",
      docs: docs(),
      consolidate_protocols: Mix.env() != :test
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp description do
    "A type-safe, K-sortable, globally unique identifier inspired by Stripe IDs"
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sloanelybutsurely/typeid-elixir"}
    ]
  end

  defp docs do
    [
      main: "TypeID",
      extras: ["CHANGELOG.md"]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.10", optional: true},
      {:phoenix_html, "~> 3.3", optional: true},
      {:phoenix, "~> 1.7", optional: true},
      {:jason, "~> 1.4", optional: true},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:yaml_elixir, "~> 2.9", only: [:dev, :test], runtime: false}
    ]
  end
end
