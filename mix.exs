defmodule TypeID.MixProject do
  use Mix.Project

  def project do
    [
      app: :typeid,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:uniq, "~> 0.5.4"}
    ]
  end
end
