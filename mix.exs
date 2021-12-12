defmodule OMC.MixProject do
  use Mix.Project

  def project do
    [
      app: :oh_my_cron,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {OMC.Application, []}
    ]
  end

  defp deps do
    [
      {:toml_elixir, "~> 2.0.0"}
    ]
  end
end
