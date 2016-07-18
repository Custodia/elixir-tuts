defmodule Todo.ProcessRegistry do
  use GenServer
  import Kernel, except: [send: 2]

  ####
  # External API

  def start_link do
    IO.inspect "Starting Todo.ProcessRegistry"
    GenServer.start_link(__MODULE__, nil, name: :process_registry)
  end


  def register_name(name, pid) do
    GenServer.call :process_registry, { :register_name, name, pid }
  end


  def whereis_name(name) do
    case :ets.lookup(:process_registry, name) do
      [{ ^name, pid }] -> pid
      _ -> :undefined
    end
  end


  def unregister_name(name) do
    GenServer.call :process_registry, { :unregister_name, name }
  end


  def send(key, message) do
    case whereis_name(key) do
      :undefined -> { :badarg, { key, message } }
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end


  ####
  # GenServer implementation

  def init(_) do
    :ets.new(:process_registry, [ :named_table, :protected, :set ])

    { :ok, nil }
  end


  def handle_call({ :register_name, key, pid }, _, state) do
    case whereis_name(key) do
      :undefined ->
        Process.monitor(pid)
        :ets.insert(:process_registry, { key, pid })
        { :reply, :yes, state }
      _otherwise -> { :reply, :no, state}
    end
  end

  def handle_call({ :unregister_name, name }, state) do
    :ets.delete(:process_registry, name)
    { :reply, name, state }
  end


  def handle_info({ :DOWN, _, :process, pid, _}, state) do
    :ets.match_delete(:process_registry, {:_, pid})
    { :noreply, state }
  end

end
