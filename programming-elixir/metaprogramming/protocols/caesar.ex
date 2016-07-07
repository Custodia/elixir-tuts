defmodule Caesar.Shared do
  def rot13(string) do
    Caesar.encrypt(string, 13)
  end
end

defprotocol Caesar do
  def encrypt(string, shift)
  defdelegate rot13(string), to: Caesar.Shared
end

defimpl Caesar, for: BitString do
  def encrypt(string, shift) do
    char_list = to_char_list string
    Caesar.encrypt(char_list, shift)
  end
end

defimpl Caesar, for: List do
  defp bound_char(char) do
    cond do
      char < ?a ->
        ?z + (char - ?a) + 1
      char > ?z ->
        ?a + (char - ?z) - 1
      true      ->
        char
    end
  end

  def encrypt(string, shift) do
    if Enum.all?(string, &(&1 in ?a..?z)) do
      Enum.map(string, &(bound_char(&1 + shift)))
    else
      throw "Not a lowercase string"
    end
  end
end

defmodule Caesar.Test do

  def println_test do
    IO.puts "#{Caesar.rot13("koira")} should be xbven"
    IO.puts "#{Caesar.rot13('koira')} should be xbven"

    IO.puts "#{Caesar.encrypt("xbven", -13)} should be koira"
    IO.puts "#{Caesar.encrypt('xbven', -13)} should be koira"
  end

end
