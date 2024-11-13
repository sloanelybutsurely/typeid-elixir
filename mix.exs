defmodule TypeID.MixProject do
  use Mix.Project

  @version "1.1.0"

  def project do
    [
      app: :typeid_elixir,
      version: @version,
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      aliases: aliases(),
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

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:phoenix_html, "~> 3.3 or ~> 4.0", optional: true},
      {:phoenix, "~> 1.7", optional: true},
      {:jason, "~> 1.4", optional: true},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:yaml_elixir, "~> 2.9", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.10", only: [:dev, :test]},
      {:postgrex, "~> 0.17", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
