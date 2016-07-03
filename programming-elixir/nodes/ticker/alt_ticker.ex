defmodule Ticker do
  @interval 2000
  @name     :ticker


  def start do
    pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@name, pid)
  end


  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end


  def generator([], []) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([pid], [pid])
    end
  end
  def generator(clients, []), do: generator(clients, clients)
  def generator(clients, [next | tail]) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(clients ++ [pid], [ next | tail ] ++ [pid])
    after
      @interval ->
        IO.puts "tick"
        send next, { :tick }
        generator(clients, tail)
    end
  end

end
