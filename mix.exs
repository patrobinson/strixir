defmodule Strixir.Mixfile do
  use Mix.Project

  def project do
    [app: :strixir,
     version: "0.1.0",
     elixir: "~> 1.3",
     name: "Strixir",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [ :httpoison, :exjsx, :logger ],
     mod: {Strixir, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:httpoison, "~> 0.8"},
     {:exjsx, "~> 3.2"}]
  end
end
