defmodule Beacon.LiveAdmin.MixProject do
  use Mix.Project

  def project do
    [
      app: :beacon_live_admin,
      version: "0.1.0-dev",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Beacon.LiveAdmin.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      beacon_dep(),
      {:phoenix, "~> 1.7"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18"},
      {:floki, ">= 0.30.0", only: :test},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  defp beacon_dep do
    if path = System.get_env("BEACON_PATH") do
      {:beacon, path: path, runtime: false}
    else
      {:beacon, github: "beaconCMS/beacon", runtime: false}
    end
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      dev: "run --no-halt dev.exs",
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": [
        "tailwind default",
        "esbuild module",
        "esbuild main",
        "esbuild cdn",
        "esbuild cdn_min"
      ],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
