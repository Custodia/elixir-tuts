defmodule Todo.Server do
  use GenServer


  ####
  # External API

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end


  def add_entry(entry) do
    is_valid? entry
    GenServer.cast __MODULE__, { :add, entry }
  end


  def entries(date) do
    GenServer.call __MODULE__, { :entries, date }
  end


  def update_entry(new_entry) do
    update_entry(new_entry.id, fn _ -> new_entry end)
  end

  def update_entry(id, func) do
    GenServer.cast __MODULE__, { :update, id, func }
  end


  def remove_entry(id) do
    GenServer.cast __MODULE__, { :remove, id }
  end


  ####
  # Helper methods

  def is_valid?(entry) do
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
