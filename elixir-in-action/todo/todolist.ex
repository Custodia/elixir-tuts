defmodule TodoList do
  defstruct auto_id: 1, entries: HashDict.new

  def new, do: %TodoList{}


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

end
