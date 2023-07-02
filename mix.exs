defmodule TypeID.MixProject do
  use Mix.Project

  def project do
    [
      app: :typeid_elixir,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "TypeID Elixir",
      source_url: "https://github.com/sloanelybutsurely/typeid-elixir"
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

  defp deps do
    [
      {:uniq, "~> 0.5.4"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:yaml_elixir, "~> 2.9", only: [:dev, :test], runtime: false}
    ]
  end
end
