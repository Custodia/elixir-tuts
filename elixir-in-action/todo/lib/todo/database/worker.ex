defmodule Todo.Database.Worker do
  use GenServer


  ####
  # External API

  def start_link(worker_id) do
    IO.inspect "Starting Todo.Database.Worker no: #{worker_id}"

    GenServer.start_link(
      __MODULE__, nil,
      name: via_tuple(worker_id)
    )
  end


  def store(worker_id, key, data) do
    GenServer.call via_tuple(worker_id), { :store, key, data }
  end


  def get(worker_id, key) do
    GenServer.call via_tuple(worker_id), { :get, key }
  end


  ####
  # GenServer implementation

  def init(_nil) do
    {
      :ok,
      %{
        store_job: nil,
        store_queue: HashDict.new
      }
    }
  end


  def handle_call({ :store, key, data }, from, state) do
    new_state =
      state
      |> queue_request(from, key, data)
      |> maybe_store

    { :noreply, new_state }
  end

  def handle_call({ :get, key }, _, state) do
    read_result = :mnesia.transaction(fn -> :mnesia.read({ :todo_lists, key }) end)

    data = case read_result do
      { :atomic, [ { :todo_lists, ^key, list } ] } -> list
      _ -> nil
    end

    { :reply, data, state }
  end


  def handle_info(
    { :DOWN, _, :process, pid, _ }, %{ store_job: store_job } = state)
  when pid == store_job do

    { :noreply, maybe_store(%{state | store_job: nil })}
  end

  def handle_info(:stop, state), do: { :stop, :normal, state }

  def handle_info(_, state), do: { :noreply, state }


  defp queue_request(state, from, key, data) do
    %{state | store_queue: HashDict.put(state.store_queue, key, { from, data })}
  end


  defp maybe_store(%{ store_job: nil } = state) do
    if HashDict.size(state.store_queue) > 0 do
      start_store_job(state)
    else
      state
    end
  end

  defp maybe_store(state), do: state


  defp start_store_job(state) do
    store_job = spawn_link(fn -> do_write(state.store_queue) end)

    Process.monitor(store_job)

    %{state |
      store_queue: HashDict.new,
      store_job: store_job
    }
  end


  defp do_write(store_queue) do
    { :atomic, :ok } = :mnesia.transaction(fn ->
      for { key, { _, data }} <- store_queue,
        do: :ok = :mnesia.write({ :todo_lists, key, data })

      :ok
    end)

    for { _, { from, _ }} <- store_queue, do: GenServer.reply(from, :ok)
  end

  ####
  # Helper functions

  defp via_tuple(worker_id) do
    { :via, :gproc, { :n, :l, { :database_worker, worker_id } } }
  end

end
