defmodule TypeID.MixProject do
  use Mix.Project

  @version "0.2.1"

  def project do
    [
      app: :typeid_elixir,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "TypeID Elixir",
      source_url: "https://github.com/sloanelybutsurely/typeid-elixir",
      docs: docs()
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
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:yaml_elixir, "~> 2.9", only: [:dev, :test], runtime: false}
    ]
  end
end
