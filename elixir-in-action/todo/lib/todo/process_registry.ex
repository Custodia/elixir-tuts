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
    GenServer.call :process_registry, { :whereis_name, name }
  end


  def unregister_name(name) do
    GenServer.cast :process_registry, { :unregister_name, name }
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
    { :ok, HashDict.new }
  end


  def handle_call({ :register_name, key, pid }, _, process_registry) do
    case HashDict.get(process_registry, key) do
      nil ->
        Process.monitor(pid)
        { :reply, :yes, HashDict.put(process_registry, key, pid) }
      _ ->
        { :reply, :no, process_registry }
    end
  end

  def handle_call({ :whereis_name, key }, _, process_registry) do
    {
      :reply,
      HashDict.get(process_registry, key, :undefined),
      process_registry
    }
  end


  def handle_cast({ :unregister_name, name }, process_registry) do
    { :noreply, HashDict.delete(process_registry, name) }
  end


  def handle_info({ :DOWN, _, :process, pid, _}, process_registry) do
    { :noreply, deregister_pid(process_registry, pid) }
  end


  ####
  # Helper functions

  defp deregister_pid(process_registry, pid) do
    process_registry
    |> Enum.filter(fn ({ _name, elem_pid }) -> elem_pid != pid end)
    |> Enum.into(HashDict.new)
  end

end
