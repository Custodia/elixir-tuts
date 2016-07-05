defmodule StackServer do
  use Application

  def start(_type, _args) do
    { :ok, _pid } = StackServer.Supervisor.start_link(["cat", 'cat', 347])
  end
end
