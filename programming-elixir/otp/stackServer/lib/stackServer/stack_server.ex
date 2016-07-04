defmodule StackServer.Server do
  use GenServer

  ####
  # External API

  def start_link(stack) when is_list(stack) do
    GenServer.start_link(__MODULE__, stack, name: __MODULE__)
  end


  def pop do
    GenServer.call __MODULE__, :pop
  end


  def push(val) do
    GenServer.cast __MODULE__, { :push, val }
  end


  ####
  # GenServer implementation

  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail}
  end


  def handle_cast({ :push, val }, stack) do
    { :noreply, [ val | stack ] }
  end


  def terminate(reason, state) do
    IO.puts "terminated with the reason: #{inspect reason}"
    IO.puts "the stack was:"
    IO.puts "#{inspect state}"
  end

end
