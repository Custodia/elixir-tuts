defmodule StackServer.Server do
  use GenServer


  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail}
  end


  def handle_cast({ :push, val }, stack) do
    { :noreply, [ val | stack ] }
  end

end
