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

  On :help prints out a help message to the command line and halts with 0.

  On { user, project, count } fetches issue json from the GitHub API for the
  given project and decodes it into a list of maps. In the future this will
  instead fetch the first count issues from github for the given user and project.
  """
  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({ user, project, _count }) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_list_of_maps
    |> sort_into_ascending_order
  end


  @doc """
  Handles response json coming from GitHub.

  On :ok returns body

  On :error prints a error message to console and halts with 2.
  """
  def decode_response({ :ok, body }), do: body

  def decode_response({ :error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end


  @doc """
  Converts given list of lists into a list of maps.
  """
  def convert_to_list_of_maps(list) do
    list
    |> Enum.map(&Enum.into(&1, Map.new))
  end


  @doc """
  Sorts list of issues into ascending order by the "created_at" attribute.
  """
  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues, &(&1["created_at"] <= &2["created_at"])
  end

end
