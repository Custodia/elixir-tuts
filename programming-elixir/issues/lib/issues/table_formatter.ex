defmodule Issues.TableFormatter do

  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1]


  @doc """
  Prints table for the given rows and headers.

  Rows are maps containing the given headers.
  """
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths   = widths_of(data_by_columns),
         format          = format_for(column_widths)
    do
         puts_one_line_in_columns(headers, format)
         IO.puts(separator(column_widths))
         puts_in_columns(data_by_columns, format)
    end
  end


  @doc """
  Changes issue list into a list of lists where each inner list contains
  all elements of a header.
  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end


  @doc """
  Changes anything into printable form.
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)


  @doc """
  Given all values of a column gets the width the columns should be to
  hold the biggest values.
  """
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end


  @doc """
  Generates formatting for given column widths.
  """
  def format_for(column_widths) do
    map_join(column_widths, " | ", &("~-#{&1}s")) <> "~n"
  end


  @doc """
  Makes separators for the line under the headers.
  """
  def separator(column_widths) do
    map_join(column_widths, "-+-", &(List.duplicate("-", &1)))
  end


  @doc """
  Takes column data and a formatting for each column and prints them to the
  console as a table.
  """
  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end


  @doc """
  Takes data for a single column and a format for that table and prints it to
  the console as a table row.
  """
  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end

end
