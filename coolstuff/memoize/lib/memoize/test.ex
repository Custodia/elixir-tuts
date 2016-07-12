defmodule Testi do

  def sloow do
    Process.sleep(2000)
    :ok
  end

  def error_func do
    throw "Server should still be on!"
  end

end
