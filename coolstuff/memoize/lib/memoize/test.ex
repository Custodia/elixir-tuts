defmodule Testi do

  def sloow(time_out \\ 2000) do
    Process.sleep(time_out)
    :ok
  end

  def error_func do
    throw "Server should still be on!"
  end

end


defmodule Testi2 do

  def sloow(time_out \\ 2000) do
    Process.sleep(time_out)
    :ok
  end

  def error_func do
    throw "Server should still be on!"
  end

end
