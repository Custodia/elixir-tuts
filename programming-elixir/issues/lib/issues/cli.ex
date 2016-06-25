defmodule Issues.CLI do

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the latests _n_ issues n a github project.
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :helpart.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help if help was given.`
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])

    case parse do
      { [ help: true ], _, _ } -> :help

      { _, [ user, project, count], _ } -> { user, project, String.to_integer count }

      { _, [user, project], _} -> { user, project, @default_count}

      _ -> :help
    end
  end

  @doc """
  Expects either :help or { user, project, count }.

  On :help prints out a help message to the command line.

  On { user, project, count } raises a "Not implemented" exception. In the
  future this will instead fetch the first count issues from github for the
  given user and project.
  """
  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end
  def process(_), do: raise "Not implemented"

end
