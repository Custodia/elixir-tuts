entry1 = %{date: {2013, 12, 19}, title: "Dentist"}
entry2 = %{date: {2013, 12, 20}, title: "Shopping"}
entry3 = %{date: {2013, 12, 19}, title: "Movies"}
entry4 = %{date: {2013, 12, 19}, title: "Delete me"}

todo_list =
  TodoList.new([entry1, entry2 ,entry3])
  |> TodoList.add_entry(entry4)

IO.inspect(TodoList.entries(todo_list, {2013, 12, 19}))

todo_list = TodoList.update_entry(
  todo_list,
  1,
  fn entry ->
    %{entry | id: 13, title: "Kappuchino"}
  end)

todo_list = TodoList.update_entry(
  todo_list,
  entry3 = %{id: 3, date: {2013, 12, 19}, title: "This is the third one"})

IO.inspect(TodoList.entries(todo_list, {2013, 12, 19}))

todo_list = TodoList.remove_entry(todo_list, 4)

IO.inspect(TodoList.entries(todo_list, {2013, 12, 19}))
