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

  defp take_while([], _), do: { [], [], [] }
  defp take_while([head | tail], func) do
    if func.(head) do
      { a, b, c } = take_while tail, func
      { [head | a], b, c }
    else
      { [], [head], tail }
    end
  end

  defp split_keep(list, delimiters, result) do
    case take_while list, fn x -> Enum.all?(delimiters, &(&1 != x)) end do
      { a, [], [] } -> result ++ [a]
      { _,  _, [] } -> raise "Cannot end in a delimiter"
      { _, [],  _ } -> raise "Somehow delimiter return was a empty list, this should never happen."
      { a,  b,  c } -> split_keep c, delimiters, result ++ [a] ++ [b]
    end
  end

  defp removespaces(string), do: Enum.filter string, &(&1 != ?\s)

  defp elem_to_int(str), do: _elem_to_int str, 0
  defp _elem_to_int([], value), do: value
  defp _elem_to_int([digit | tail], value) when digit in '0123456789' do
    _elem_to_int tail, value*10 + digit - ?0
  end

  defp elems_to_int([]), do: []
  defp elems_to_int([head | tail]) when head in ['*','/','+','-'] do
    [head | elems_to_int(tail)]
  end
  defp elems_to_int([head | tail]), do: [ elem_to_int(head) | elems_to_int(tail) ]

  defp split_by_math(list) do
     split_keep(list, [?+, ?-, ?*, ?/], [])
     |> Enum.map(&removespaces/1)
     |> elems_to_int
  end

  defp multiplications([l, '*', r | tail]), do: multiplications([ l*r | tail])
  defp multiplications([l, '/', r | tail]), do: multiplications([ l/r | tail])
  defp multiplications([a | tail]), do: [a | multiplications(tail)]
  defp multiplications([]), do: []

  defp additions([l, '+', r | tail]), do: additions([ l+r | tail ])
  defp additions([l, '-', r | tail]), do: additions([ l-r | tail ])
  defp additions([a | tail]), do: [a | multiplications(tail)]
  defp additions([]), do: []

  @doc """
  Given a string of numbers and math operators (*,/,+ and -) returns the
  calculation result. By elementary calculation rules operators are processed
  from the left and multiplication/division is considered before
  addition/substraction.

      iex> calculate '10 / 5 * 16 + 2 *6'
      44.0
  """
  def calculate(string) do
    [result] = split_by_math(string) |> multiplications |> additions
    result
  end

end
