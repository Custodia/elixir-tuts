defmodule BinaryManipulation do

  def capitalize_sentences(<< head::utf8, tail::binary >>) do
    String.capitalize(<<head>>) <> _capitalize_sentences(tail)
  end

  defp _capitalize_sentences(". " <> << head::utf8, tail::binary >>) do
    ". " <> String.capitalize(<<head>>) <> _capitalize_sentences(tail)
  end
  defp _capitalize_sentences(<< head::utf8, tail::binary >>) do
    String.downcase(<<head>>) <> _capitalize_sentences(tail)
  end
  defp _capitalize_sentences(<<>>), do: <<>>

end
