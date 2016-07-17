defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    IO.inspect "Starting Todo.Supervisor"
    Supervisor.start_link __MODULE__, nil
  end

  def init(_) do
    processes = [
      worker(Todo.ProcessRegistry, []),
      worker(Todo.Cache, []),
      supervisor(Todo.Database, ["./persist/"])
    ]
    supervise(processes, strategy: :one_for_one)
  end
end
