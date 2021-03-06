defmodule Todo.Database do
  @pool_size 3


  def start_link do
    :mnesia.stop
    :mnesia.create_schema([node()])
    :mnesia.start
    :mnesia.create_table(:todo_lists, [ attributes: [:name, :list], disc_only_copies: [node()] ])
    :ok = :mnesia.wait_for_tables([:todo_lists], 5000)

    Todo.Database.WorkerSupervisor.start_link(@pool_size)
  end


  def store(key, data) do
    { results, bad_nodes } =
      :rpc.multicall(
        __MODULE__, :store_local, [key, data],
        :timer.seconds(5))

    Enum.each(bad_nodes, &IO.puts("Store failed on node: #{&1}"))

    :ok
  end


  def store_local(key, data) do
    Todo.Database.Worker.store(choose_worker(key), key, data)
  end


  def get(key) do
    Todo.Database.Worker.get(choose_worker(key), key)
  end


  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end

end
