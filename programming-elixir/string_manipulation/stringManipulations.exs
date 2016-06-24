defmodule StringManipulation do

  def ascii?([]), do: true
  def ascii?([head | tail]) do
    head >= ?\s && head <= ?~ && ascii?(tail)
  end

  def anagram?([], []), do: true
  def anagram?([],  _), do: false
  def anagram?(_ , []), do: false
  def anagram?([head | tail], anagram) do
    Enum.any? anagram, &(&1 == head) && anagram?(tail, List.delete(anagram, head))
  end

end
