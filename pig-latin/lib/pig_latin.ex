defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """

  @vowels ["a", "e", "i", "o", "u"]

  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map(fn word -> translate_word(word) end)
    |> Enum.join(" ")
  end

  defp translate_word(word) do
    create_output = fn w -> w <> "ay" end
    [{first_vowel_index, length}] = Regex.run(~r/sch|thr|qu|th|[aeiou]/, word, return: :index)
    [c1, c2 | t] = word |> String.codepoints()

    cond do
      (c1 == "x" or c1 == "y") and c2 not in @vowels -> create_output.(word)
      first_vowel_index == 0 and length == 1 -> create_output.(word)
      first_vowel_index > 0 and length == 1 -> create_output.(word |> swap(first_vowel_index))
      length > 1 -> create_output.(word |> swap(first_vowel_index + length))
    end
  end

  defp swap(phrase, first_vowel_index) do
    phrase_length = phrase |> String.length()
    first_part = phrase |> String.slice(0, first_vowel_index)
    second_part = phrase |> String.slice(first_vowel_index, phrase_length - first_vowel_index)
    second_part <> first_part
  end
end
