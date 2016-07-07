defmodule My do

  defmacro unless(condition, clauses) do
    do_clause   = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)
    quote do
      case unquote(condition) do
        val when val in [false, nil] -> unquote(do_clause)
        _                            -> unquote(else_clause)
      end
    end
  end

end


defmodule Test do
  require My

  My.unless 1 == 2, do: (IO.puts "This is correct"), else: (IO.puts "This is incorrect")
  My.unless 1 == 1, do: (IO.puts "This is incorrect"), else: (IO.puts "This is correct") 
end
