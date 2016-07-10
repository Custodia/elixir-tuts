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


end
