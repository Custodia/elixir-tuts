defmodule Spawn do
  def answer do
    receive do
      {sender, msg} ->
        send sender, "Hello it's #{inspect(msg)}"
    end
  end
end

fred  = spawn(Spawn, :answer, [])
betty = spawn(Spawn, :answer, [])

send fred,  {self, :fred}
send betty, {self, :betty}

receive do
  msg -> IO.puts msg
end
receive do
  msg -> IO.puts msg
end
