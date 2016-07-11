defmodule Parallel do

  defp process(func) do
    receive do
      pid ->
        process(func, pid)
    end
  end

  defp process(func, next_pid) do
    receive do
      :done ->
        send next_pid, :done

      elem ->
        send next_pid, func.(elem)
        process(func, next_pid)
    end
  end

  defp send_pids([last], self), do: send last, self
  defp send_pids([ head, next | tail ], self) do
    send head, next
    send_pids([next | tail], self)
  end

  defp receive_results(collection) do
    receive do
      :done -> collection

      elem -> receive_results([elem | collection])
    end
  end


  @doc """
  Maps a collection in parallel vertically.

  Takes a collection of elements, a collection of functions and makes a
  process for each function passing elements function to function.

  ## Example

      iex> collection = [1, 2, 3, 4]
      iex> funcs = [&(&1 + 1), &(&1 * 2), &(to_string(&1))]
      iex> Parallel.vert_pmap(collection, funcs)
      ["4", "6", "8", "10"]
  """
  def vert_pmap(collection, funcs) do
    [ first_pid | _tail ] = pids = funcs
    |> Enum.map(fn func -> spawn_link fn -> process(func) end end)

    send_pids(pids, self)

    collection |> Enum.each(fn (elem) -> send first_pid, elem end)
    send first_pid, :done

    receive_results([]) |> Enum.reverse()
  end


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
