defmodule Weatherapp.CLI do

  @moduledoc """
  Handle command line parsing and the dispatch to the various
  functions that end up generating the formatted tables based on the
  given parameters
  """

  require Logger

  @doc """
  Main function that command line parameters are passed to.

  Will later parse arguments and pass them to be processed.
  """
  def main(argv) do
    argv
    |> parse_args
    |> process
  end


  @doc """
  Parse arguments given from the command line.

  Given -h or --help returns :help

  Given anything else returns :argument_error
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean ],
                                     aliases:  [ h:    :help ])

    case parse do
      { [ help: true ], _, _ } -> :help

      _ -> :argument_error
    end
  end


  @doc """
  Process data parsed from the command line arguments

  Given :help prints out a help message and halts with 0.

  Given :argument_error logs the error and halts with 2.
  """
  def process(:help) do
    IO.puts """
    A tool for fetching and displaying weather data
    """
    System.halt(0)
  end

  def process(:argument_error) do
    Logger.error "Invalid command line arguments for Weatherapp"
    System.halt(2)
  end

end
