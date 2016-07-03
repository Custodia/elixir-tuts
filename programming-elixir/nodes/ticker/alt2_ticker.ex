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


  def generator(clients, toSend) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(clients ++ [pid], toSend ++ [pid])
    after
      @interval ->
        IO.puts "tick"
        send_tick clients, toSend
    end
  end

  defp send_tick([], []), do: generator([], [])
  defp send_tick(clients, []), do: send_tick(clients, clients)
  defp send_tick(clients, [next | tail]) do
    send next, { :tick }
    generator(clients, tail)
  end

end
