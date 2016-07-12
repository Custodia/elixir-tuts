defmodule Memoize.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end


  def memoize(module, function, params) do
    GenServer.call __MODULE__, { :memoize, module, function, params }
  end


  def init([]) do
    { :ok, Map.new }
  end

  def handle_call({ :memoize, module, function, params }, _from, map_set) do
    key = { module, function , params}
    IO.inspect(map_set)
    if (Map.has_key?(map_set, key)) do
      value = Map.get(map_set, key)
      { :reply, value, map_set }
    else
      value = apply(module, function, params)
      map_set = Map.put(map_set, key, value)
      { :reply, value, map_set }
    end
  end



end
