defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    candidates |> Enum.filter(fn c -> is_anagram(base, c) end)
  end

  def is_anagram(word1, word2) do
    word1_downcase = word1 |> String.downcase()
    word2_downcase = word2 |> String.downcase()
    codepoint1 = word1_downcase |> String.codepoints() |> Enum.sort()
    codepoint2 = word2_downcase |> String.downcase() |> String.codepoints() |> Enum.sort()
    codepoint1 == codepoint2 && word1_downcase != word2_downcase
  end
end
