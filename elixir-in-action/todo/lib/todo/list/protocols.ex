defimpl String.Chars, for: Todo.List do
  def to_string(%Todo.List{entries: entries}) do
    id_max_length =
      Enum.map(entries, fn { id, _ } -> String.length("#{id}") end)
      |> Enum.max()

    "%Todo.List\n{\n" <>
    (entries
    |> Enum.sort_by(fn {id, _} -> id end)
    |> Enum.map(fn {id, %{ date: { year, month, day }, title: title}} ->
        "    id: #{String.pad_leading("#{id}", id_max_length)},  "
        <> "date: #{year}/" <>
        "#{String.pad_leading("#{month}", 2, "0")}" <>
        "/#{String.pad_leading("#{day}",  2, "0")}," <>
        "  title: #{title}\n"
      end)
    |> Enum.reduce(&(&2 <> &1))) <>
    "}"
  end
end

defimpl Collectable, for: Todo.List do

  def into(original) do
    { original, &into_callback/2 }
  end


  defp into_callback(todo_list, {:cont, entry}) do
    Todo.List.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list,  :done), do: todo_list
  defp into_callback(_todo_list, :halt), do: :ok

end

defimpl Enumerable, for: Todo.List do

  def reduce(%Todo.List{entries: entries}, acc, fun) do
    entries =
      entries |> HashDict.to_list()
      |> Enum.sort_by(fn { id, _entry } -> id end)
      |> Enum.map(fn { _id, entry } -> entry end)
    do_reduce(entries, acc, fun)
  end

  defp do_reduce(_ ,    {:halt, acc}, _fun),   do: {:halted, acc}
  defp do_reduce(list,  {:suspend, acc}, fun), do: {:suspended, acc, &do_reduce(list, &1, fun)}
  defp do_reduce([],    {:cont, acc}, _fun),   do: {:done, acc}
  defp do_reduce([h|t], {:cont, acc}, fun),    do: do_reduce(t, fun.(h, acc), fun)


  def member?(%Todo.List{entries: entries}, %{date: date, title: title}) do
    result = entries |> Enum.any?(fn { _id, entry } ->
      entry.date == date && entry.title == title
    end)
    { :ok, result }
  end

  def member?(%Todo.List{entries: entries}, id) do
    result = entries |> Enum.any?(fn {entry_id, _entry} -> entry_id == id end)
    { :ok, result }
  end


  def count(%Todo.List{entries: entries}) do
    { :ok, Enum.count(entries) }
  end

end
