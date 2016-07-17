defmodule Todo.Database do
  use GenServer

  @pool_size 3

  ####
  # External API

  def start_link(db_folder) do
    Todo.Database.WorkerSupervisor.start_link(db_folder, @pool_size)
  end


  def store(key, data) do
    key
    |> choose_worker
    |> Todo.Database.Worker.store(key, data)
  end


  def get(key) do
    key
    |> choose_worker
    |> Todo.Database.Worker.get(key)
  end


  ####
  # Helper functions

  def choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end

end
