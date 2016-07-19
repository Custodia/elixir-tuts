defmodule Todo.Server do
  use GenServer


  ####
  # External API

  def start_link(list_name) do
    IO.inspect "Starting Todo.Server for todo list: #{list_name}"
    GenServer.start_link(__MODULE__, list_name, name: via_tuple(list_name))
  end


  def add_entry(pid, entry) do
    is_valid? entry
    GenServer.cast pid, { :add, entry }
  end


  def entries(pid, date) do
    GenServer.call pid, { :entries, date }
  end


  def update_entry(pid, new_entry) do
    update_entry(pid, new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(pid, id, func) do
    GenServer.cast pid, { :update, id, func }
  end


  def remove_entry(pid, id) do
    GenServer.cast pid, { :remove, id }
  end


  def whereis_name(name) do
    :gproc.whereis_name({ :n, :l, { :todo_server, name } })
  end


  ####
  # Helper methods

  defp is_valid?(entry) do
    %{ date: { _, _, _ }, title: _ } = entry
    entry
  end


  defp via_tuple(name) do
    { :via, :gproc, { :n, :l, { :todo_server, name } } }
  end


  ####
  # GenServer implementation

  def init(list_name) do
    { :ok, { list_name, Todo.Database.get(list_name) || Todo.List.new } }
  end


  def handle_call({ :entries, date }, _from, { list_name, todo_list }) do
    %Todo.List{} = todo_list
    { :reply, Todo.List.entries(todo_list, date), { list_name, todo_list } }
  end


  def handle_cast({ :add, entry }, { list_name, todo_list }) do
    %Todo.List{} = todo_list
    new_state = Todo.List.add_entry(todo_list,entry)
    Todo.Database.store(list_name, new_state)
    { :noreply, { list_name, new_state } }
  end

  def handle_cast({ :update, id, func }, { list_name, todo_list }) do
    %Todo.List{} = todo_list
    new_state = Todo.List.update_entry(todo_list, id, func)
    Todo.Database.store(list_name, new_state)
    { :noreply, { list_name, new_state } }
  end

  def handle_cast({ :remove, id }, { list_name, todo_list }) do
    %Todo.List{} = todo_list
    new_state = Todo.List.remove_entry(todo_list, id)
    Todo.Database.store(list_name, new_state)
    { :noreply, { list_name, new_state } }
  end

end
