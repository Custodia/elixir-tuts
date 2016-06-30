defmodule CatSolver do

  def cat(scheduler) do
    send scheduler, { :ready, self }
    receive do
      { :task, path, client} ->
        send client, { :answer, path, count_cats(path), self }
        cat(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  defp count_cats(path) do
    case File.read(path) do
      { :ok, binary } ->
        binary
        |> String.split("\n")
        |> Enum.flat_map(fn line -> String.split(line, " ") end)
        |> Enum.filter(&(&1 == "cat"))
        |> Enum.count()
      { :error, _} ->
        IO.puts "Error reading file"
        0
    end
  end

end
