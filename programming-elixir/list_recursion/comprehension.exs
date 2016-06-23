defmodule Comprehension do

  def primes(n) when n < 2 do
    []
  end
  def primes(n) do
    for x <- 2..n, isprime?(x), do: x
  end

  defp isprime?(2), do: true
  defp isprime?(3), do: true
  defp isprime?(n) do
    Enum.all? 2..div(n, 2), fn x -> rem(n, x) != 0 end
  end

end
