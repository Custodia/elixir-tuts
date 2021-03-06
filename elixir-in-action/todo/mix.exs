defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.0",
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :gproc, :cowboy, :plug],
      included_applications: [:mnesia],
      mod: { Todo.Application, [] }
    ]
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
      { :gproc, "0.3.1" },
      { :cowboy, "1.0.0" },
      { :plug, "1.1.6" },
      { :meck, "0.8.2", only: :test },
      { :httpoison, "0.8.0", only: :test },
      { :exrm, "1.0.5" }
    ]
  end
end
