defmodule ABACthem.MixProject do
  use Mix.Project

  def project do
    [
      app: :abac_them,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ABACthem.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:decorator, "~> 1.2"},
      {:poison, "~> 3.1"},
      {:tesla, "~> 1.2.1"}
    ]
  end
end
