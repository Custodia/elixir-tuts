defmodule Weatherapp.Mixfile do
  use Mix.Project

  def project do
    [app: :weatherapp,
     version: "0.1.0",
     name: "Weatherapp",
     source_url: "https://github.com/custodia/elixir-tuts",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [ applications: [ :logger, :httpoison ] ]
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
    [
      ex_doc:    "~> 0.11",
      earmark:   ">= 0.0.0",
      httpoison: "~> 0.8"
    ]
  end
end
