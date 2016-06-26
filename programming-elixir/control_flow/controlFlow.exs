defmodule ControlFlow do

  def fizzbuzz(n) do
    case { n, rem(n, 3), rem(n, 5) } do
      { _, 0, 0 } -> "FizzBuzz"
      { _, 0, _ } -> "Fizz"
      { _, _, 0 } -> "Buzz"
      { n, _, _ } -> n
    end
  end

  def ok!(tuple) do
    case tuple do
      { :ok, data } -> data
      { :error, reason } when is_bitstring(reason) -> raise reason
      _ -> raise "ok! is expecting a return of { :ok, data }" <>
                 "or { :error, string } but instead got something else"
    end
  end

end
