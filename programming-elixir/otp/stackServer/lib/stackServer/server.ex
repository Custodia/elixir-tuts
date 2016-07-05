defmodule StackServer.Server do
  use GenServer

  ####
  # External API

  def start_link(stash_pid) when is_pid(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end
  def start_link(stack) when is_list(stack) do
    IO.puts "Tried to init server with stack instead of pid for stash"
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end


  def push(val) do
    GenServer.cast __MODULE__, { :push, val }
  end


  ####
  # GenServer implementation

  def init(stash_pid) do
    stack = StackServer.Stash.get_stack stash_pid
    { :ok, { stack, stash_pid } }
  end


  def handle_call(:pop, _from, {[head | tail], stash_pid}) do
    { :reply, head, {tail, stash_pid}}
  end


  def handle_cast({ :push, val }, {stack, stash_pid}) do
    { :noreply, {[ val | stack ], stash_pid} }
  end


  def terminate(_reason, { stack, stash_pid }) do
    StackServer.Stash.save_stack stash_pid, stack
  end

end
