defmodule TodoList.CsvImporter do

  def import!(file_name) do
    File.stream!(file_name)
    |> Enum.map(&parse_line/1)
    |> TodoList.new()
  end


  defp parse_line(<< year::bitstring-size(32) >>  <> "/" <>
                  << month::bitstring-size(16) >> <> "/" <>
                  << day::bitstring-size(16) >>   <> "," <>
                  << title::bitstring >>) do
    %{ date: { year, month, day }, title: String.trim(title)}
  end

end
