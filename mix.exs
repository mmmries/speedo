defmodule Speedo.MixProject do
  use Mix.Project

  def project do
    [
      app: :speedo,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Speedo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_gpio, "~> 0.4"},

      {:ex_doc, "~> 0.15", only: :dev}
    ]
  end

  defp package do
    %{
      description: "Measure revolutions per second via a GPIO pin",
      licenses: ["MIT"],
      links: %{
        github: "http://github.com/mmmries/speedo"
      },
      maintainers: ["Michael Ries"]
    }
  end
end
