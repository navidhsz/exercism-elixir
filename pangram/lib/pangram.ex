defmodule Pangram do
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    char_range = ?a..?z
    len = 26

    case length(
           sentence
           |> String.downcase()
           |> String.to_charlist()
           |> Enum.filter(fn c -> c in char_range end)
           |> Enum.group_by(fn c -> c end)
           |> Enum.to_list()
         ) do
      ^len -> true
      _ -> false
    end
  end
end
