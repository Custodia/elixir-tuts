entries = [
  %{ date: { 2013, 12, 19 }, title: "Dentist" },
  %{ date: { 2013, 12, 20 }, title: "Shopping" },
  %{ date: { 2013, 12, 19 }, title: "Movies" }
]

todo_list = for entry <- entries, into: TodoList.new, do: entry

IO.puts todo_list

member1 = Enum.member?(todo_list, 3)
member2 = Enum.member?(todo_list, %{ date: { 2013, 12, 20 }, title: "Shopping" })

member3 = Enum.member?(todo_list, 4)
member4 = Enum.member?(todo_list, %{ date: { 2013, 12, 20 }, title: "Movies" })

IO.puts "member1 should be true  and is #{member1}"
IO.puts "member2 should be true  and is #{member2}"
IO.puts "member3 should be false and is #{member3}"
IO.puts "member4 should be false and is #{member4}"

todo_count = Enum.count(todo_list)

IO.puts "Count should be 3 and is #{todo_count}"

todo_reduce_title =
  todo_list
  |> Enum.reduce(
    "",
    fn( %{ date: _, title: title }, acc) ->
      acc <> title
    end)

IO.puts "Titles concatenated: #{todo_reduce_title}"

todos_mapped =
  todo_list
  |> Enum.map(fn %{ date: _, title: title } = entry ->
    %{entry | title: "#{title} kappapride"}
  end)
  |> Enum.into(TodoList.new)

IO.puts todos_mapped
