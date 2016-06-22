prefix = fn
  first -> fn
    second -> "#{first} #{second}"
  end
end

IO.puts prefix.("Mrs").("Smith")
IO.puts prefix.("Elixir").("Rocks")

IO.puts prefix.(:what_about).(:atoms)
