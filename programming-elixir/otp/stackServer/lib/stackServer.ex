defmodule StackServer do
  use Application

  def start(_type, initial_stack) do
    { :ok, _pid } = StackServer.Supervisor.start_link(initial_stack)
  end
end
