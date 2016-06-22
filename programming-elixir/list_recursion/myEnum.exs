defmodule MyEnum do

  def all?([], _func), do: true
  def all?([head | tail], func) do
    if func.(head),
    do: all?(tail, func),
    else: false
  end

  def each([], _func), do: :ok
  def each([head | tail], func) do
    func.(head)
    each(tail, func)
  end

  def filter([], _func), do: []
  def filter([head | tail], func) do
    if func.(head),
    do: [head | filter(tail, func)],
    else: filter(tail, func)
  end

  def split(list, index), do: [Enum.take(list, index), Enum.drop(list, index)]

  def take(_list, 0), do: []
  def take([head | tail], n), do: [head | take(tail, n - 1)]

  def flatten([ head | tail ]) when not is_list(head) do
    [head | flatten(tail)]
  end
  def flatten([ head | tail ]),
    do: flatten(head) ++ flatten(tail)
  def flatten([]), do: []

end
