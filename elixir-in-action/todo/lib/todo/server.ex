defmodule Todo.Server do
  use GenServer


  ####
  # External API

  def start do
    GenServer.start_link(__MODULE__, nil)
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


  ####
  # Helper methods

  defp is_valid?(entry) do
    %{ date: { _, _, _ }, title: _ } = entry
    entry
  end


  ####
  # GenServer implementation

  def init(nil) do
    { :ok, Todo.List.new }
  end


  def handle_call({ :entries, date }, _from, %Todo.List{} = todo_list) do
    { :reply, Todo.List.entries(todo_list, date), todo_list }
  end


  def handle_cast({ :add, entry }, %Todo.List{} = todo_list) do
    { :noreply, Todo.List.add_entry(todo_list,entry) }
  end

  def handle_cast({ :update, id, func }, %Todo.List{} = todo_list) do
    { :noreply, Todo.List.update_entry(todo_list, id, func) }
  end

  def handle_cast({ :remove, id }, %Todo.List{} = todo_list) do
    { :noreply, Todo.List.remove_entry(todo_list, id) }
  end

end
