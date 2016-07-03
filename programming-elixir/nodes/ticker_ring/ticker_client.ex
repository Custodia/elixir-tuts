defmodule Ticker.Client do
  @interval 2000

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end


  def receiver do
    receive do
      { :forward_addr, pid } ->
        receiver(pid)
    end
  end
  def receiver(pid) do
    receive do
      { :forward_addr, new_pid } ->
        receiver(new_pid)
      { :tick } ->
        IO.puts "tock in client"
        spawn(__MODULE__, :forward, [pid])
        receiver(pid)
    end
  end


  def forward(pid) do
    :timer.sleep(@interval)
    send pid, { :tick }
  end

end
