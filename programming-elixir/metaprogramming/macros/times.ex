defmodule Times do
  defmacro times_n(times) do
    quote do
      def unquote(:"times_#{times}")(x) do
        unquote(times) * x
      end
    end
  end
end



defmodule Test do
  require Times
  Times.times_n(3)
  Times.times_n(4)
end

IO.puts Test.times_3(4)
IO.puts Test.times_4(5)
