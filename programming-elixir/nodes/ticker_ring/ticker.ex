defmodule Ticker do
  @name     :ticker


  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end


  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end


  def generator([]) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        send pid, { :forward_addr, pid }
        send pid, { :tick }
        generator([pid])
    end
  end
  def generator(clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        add_to_chain(clients, pid)
        generator(clients ++ [pid])
    end
  end


  defp add_to_chain(clients, new_pid) do
    [ first | _ ] = clients
    last = List.last(clients)

    send last,    { :forward_addr, new_pid }
    send new_pid, { :forward_addr, first }
  end

end
