defmodule TodoList do
  defstruct auto_id: 1, entries: HashDict.new

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, todo_list -> add_entry(todo_list, entry) end)
  end

  def add_entry(old_list = %TodoList{auto_id: id, entries: old_entries}, entry) do
    entry = Map.put(entry, :id, id)
    new_entries = HashDict.put(old_entries, id, entry)
    %TodoList{ old_list |
      auto_id: id + 1,
      entries: new_entries
    }
  end


  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn { _key, entry } -> entry.date == date end)
    |> Enum.map(     fn { _key, entry } -> entry end)
  end


  def update_entry(todo_list, %{id: _, date: _, title: _} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(%TodoList{entries: entries} = todo_list, id, func) do
    case entries[id] do
      nil -> todo_list

      old_entry ->
        new_entry   = %{id: _, date: _, title: _} = func.(old_entry)
        new_entry   = %{ new_entry | id: old_entry.id }
        new_entries = HashDict.put(entries, old_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end


  def remove_entry(%TodoList{entries: entries} = todo_list, id) do
    new_entries = entries
    |> Enum.filter(fn {entry_id, _entry} -> entry_id != id end)
    %TodoList{todo_list | entries: new_entries}
  end

end

defimpl String.Chars, for: TodoList do
  def to_string(%TodoList{entries: entries}) do
    id_max_length =
      Enum.map(entries, fn { id, _ } -> String.length("#{id}") end)
      |> Enum.max()

    "%TodoList\n{\n" <>
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

defimpl Collectable, for: TodoList do

  def into(original) do
    { original, &into_callback/2 }
  end


  defp into_callback(todo_list, {:cont, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(todo_list, :halt), do: :ok

end

defimpl Enumerable, for: TodoList do

  def reduce(%TodoList{entries: entries}, acc, fun) do
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


  def member?(%TodoList{entries: entries}, %{date: date, title: title}) do
    result = entries |> Enum.any?(fn { _id, entry } ->
      entry.date == date && entry.title == title
    end)
    { :ok, result }
  end

  def member?(%TodoList{entries: entries}, id) do
    result = entries |> Enum.any?(fn {entry_id, _entry} -> entry_id == id end)
    { :ok, result }
  end


  def count(%TodoList{entries: entries}) do
    { :ok, Enum.count(entries) }
  end

end
