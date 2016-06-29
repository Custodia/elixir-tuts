defmodule Weatherapp.CLI do

  @moduledoc """
  Handle command line parsing and the dispatch to the various
  functions that end up generating the formatted tables based on the
  given parameters
  """


  @doc """
  Main function that command line parameters are passed to.

  Will later parse arguments and pass them to be processed.
  """
  def main(argv) do
    argv
    |> parse_args
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

end
