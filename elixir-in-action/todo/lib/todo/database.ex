defmodule Todo.Database do
  use GenServer

  @workers 3

  ####
  # External API

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: :database_server)
  end


  def store(key, data) do
    worker_id = :erlang.phash2(key, @workers)
    worker = GenServer.call :database_server, { :get_worker, worker_id }

    GenServer.cast worker, { :store, key, data }
  end


  def get(key) do
    worker_id = :erlang.phash2(key, @workers)
    worker = GenServer.call :database_server, { :get_worker, worker_id }

    GenServer.call worker, { :get, key }
  end


  ####
  # GenServer implementation

  def init(db_folder) do
    File.mkdir_p!(db_folder)

    worker_map = 1..@workers
    |> Enum.map(&{ &1 - 1, Todo.Database.Worker.start(db_folder) })
    |> Map.new()

    { :ok, worker_map }
  end


  def handle_call({ :get_worker, key }, caller, worker_map) do
    worker = Map.get(worker_map, key)
    { :reply, worker, worker_map }
  end


  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"

end
