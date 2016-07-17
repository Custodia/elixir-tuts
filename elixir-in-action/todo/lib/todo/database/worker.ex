defmodule Todo.Database.Worker do
  use GenServer


  ####
  # External API

  def start_link(db_folder, worker_id) do
    IO.inspect "Starting Todo.Database.Worker no: #{worker_id}"
    GenServer.start_link(
      __MODULE__,
      db_folder,
      name: via_tuple(worker_id)
    )
  end


  def store(worker_id, key, data) do
    GenServer.cast via_tuple(worker_id), { :store, key, data }
  end


  def get(worker_id, key) do
    GenServer.call via_tuple(worker_id), { :get, key }
  end


  ####
  # GenServer implementation

  def init(db_folder) do
    { :ok, db_folder }
  end


  def handle_cast({ :store, key, data }, db_folder) do
    spawn(fn ->
      file_name(db_folder, key)
      |> File.write!(:erlang.term_to_binary(data))
    end)

    { :noreply, db_folder}
  end


  def handle_call({ :get, key }, caller, db_folder) do
    spawn(fn ->
      data = case File.read(file_name(db_folder, key)) do
        { :ok, contents } -> :erlang.binary_to_term(contents)
        _ -> nil
      end

      GenServer.reply(caller, data)
    end)

    { :noreply, db_folder }
  end


  ####
  # Helper functions

  defp via_tuple(worker_id) do
    { :via, Todo.ProcessRegistry, { :database_worker, worker_id } }
  end


  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"

end
