defmodule RecurseList do

  def mapsum([], _), do: 0
  def mapsum([head | tail], func) do
    func.(head) + mapsum(tail, func)
  end

  def max([ head | []]), do: head
  def max([ head | tail ]) do
    next = max(tail)
    case head do
      head when head > next -> head
      head -> next
    end
  end

  def caesar([], _), do: []
  def caesar([head | tail], n) do
    char = head + n
    [a, z] = 'az'
    case char do
      c when c > z -> [a +  char - z - 1] ++ caesar(tail, n)
      c -> [char] ++ caesar(tail, n)
    end
  end

end
