defmodule Todo.Supervisor do
  use Supervisor


  def start_link do
    IO.inspect "Starting Todo.Supervisor"
    Supervisor.start_link __MODULE__, nil
  end


  def init(_) do
    processes = [
      supervisor(Todo.Database, []),
      supervisor(Todo.ServerSupervisor, [])
    ]
    supervise(processes, strategy: :one_for_one)
  end

end
