defmodule StackServer.Stash do
  use GenServer

  ####
  # External API

  def start_link(stack) do
    { :ok, _pid } = GenServer.start_link(__MODULE__, stack)
  end


  def save_stack(pid, stack) do
    GenServer.cast pid, { :save_stack, stack }
  end


  def get_stack(pid) do
    GenServer.call pid, :get_stack
  end


  ####
  # GenServer implementation

  def handle_call(:get_stack, _from, stack) do
    { :reply, stack, stack }
  end


  def handle_cast({ :save_stack, new_stack }, _stack) do
    { :noreply, new_stack }
  end

end
