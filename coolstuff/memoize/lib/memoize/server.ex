defmodule Memoize.Server do
  use GenServer


  ####
  # External API

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


  def flush(module, function \\ nil, params \\ nil) do
    GenServer.cast __MODULE__, { :flush, { module, function, params } }
  end


  def init([]) do
    { :ok, Map.new }
  end


  ####
  # GenServer implementation

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


  def handle_cast({ :flush, { module, function, params } }, map) do
    new_map = map
    |> Enum.filter(fn ({ key, _value }) ->
      case key do
        { ^module, ^function, ^params } -> false
        { ^module, ^function, _params } when params == nil -> false
        { ^module, _function, _params } when params == nil and function == nil -> false
        _otherwise                      -> true
      end
    end)
    |> Map.new()
    { :noreply, new_map }
  end

end
