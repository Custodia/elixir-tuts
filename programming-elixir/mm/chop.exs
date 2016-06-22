defmodule Chop do

  def guess(actual, first..last) when actual < div(first + last, 2) do
    last = div(first + last, 2)
    IO.puts "Is it #{last}"
    guess(actual, first..last)
  end

  def guess(actual, first..last) when actual > div(first + last, 2) do
    first = div(first + last, 2)
    IO.puts "Is it #{first}"
    guess(actual, first..last)
  end

  def guess(actual, first..last) when actual == div(first + last, 2) do
    answer = div(first + last, 2)
    IO.puts "Is it #{answer}"
    answer
  end

end
