defmodule Parallel do

  @doc """
  Maps a collection in parallel. Creates a process for each element.

  ## Example

      iex> Parallel.pmap(1..1_000, fn(int) -> Process.sleep(1_000); int * int end)
      [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324,
      361, 400, 441, 484, 529, 576, 625, 676, 729, 784, 841, 900, 961, 1024, 1089,
      1156, 1225, 1296, 1369, 1444, 1521, 1600, 1681, 1764, 1849, 1936, 2025, 2116,
      2209, 2304, 2401, 2500, ...]
  """
  def pmap(collection, func) do
    me = self
    collection
      |>  Enum.map(fn (elem) ->
            spawn_link fn -> (send me, { self, func.(elem) }) end
          end)
      |>  Enum.map(fn (pid) ->
            receive do { ^pid, result } -> result end
          end)
  end

end
