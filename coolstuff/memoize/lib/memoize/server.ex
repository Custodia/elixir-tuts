defmodule Memoize.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end


  def memoize(module, function, params) do
    case GenServer.call __MODULE__, { :get, { module, function, params } } do
      :nope -> send_answer(module, function, params)

      value -> value
    end
  end


  def send_answer(module, function, params) do
    result = apply(module, function, params)
    GenServer.cast __MODULE__, { :set, { module, function, params }, result }
    result
  end


  def init([]) do
    { :ok, Map.new }
  end


  def handle_call({ :get, key }, _from, map) do
    { _module, _function, _params } = key
    IO.inspect(map)
    if (Map.has_key?(map, key)) do
      value = Map.get(map, key) 
      { :reply, value, map }
    else
      { :reply, :nope, map }
    end
  end

  def handle_cast({ :set, key, value}, map) do
    { _module, _function, _params } = key
    map = Map.put(map, key, value)
    IO.inspect(map)
    { :noreply, map }
  end


end
