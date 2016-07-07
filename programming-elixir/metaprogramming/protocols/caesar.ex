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
    to_string(Caesar.encrypt(char_list, shift))
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


defmodule Caesar.File do

  defp process_words(words), do: process_words(words, MapSet.new)

  defp process_words([], set), do: set
  defp process_words([head | tail], set) do
    encrypted = Caesar.rot13(head)
    if Enum.any?(tail, &(&1 == encrypted)),
    do: process_words(tail, set |> MapSet.put(head) |> MapSet.put(encrypted)),
    else: process_words(tail, set)
  end

  def scan_file(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Enum.flat_map(&String.split/1)
    |> process_words
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
