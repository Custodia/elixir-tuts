entries = [
  %{ date: { 2013, 12, 19 }, title: "Dentist" },
  %{ date: { 2013, 12, 20 }, title: "Shopping" },
  %{ date: { 2013, 12, 19 }, title: "Movies" }
]

todo_list = for entry <- entries, into: TodoList.new, do: entry

IO.puts todo_list
