defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.codepoints()
    |> Enum.filter(fn c -> c != " " and c != "-" end)
    |> Enum.group_by(fn c -> c end)
    |> Map.to_list()
    |> is_isogram
  end

  defp is_isogram(chars) do
    [h | t] = chars

    case h do
      {c, l} when length(l) > 1 -> false
      {c, l} when length(l) == 1 and t != [] -> is_isogram(t)
      {c, l} when length(l) == 1 and t == [] -> true
    end
  end
end
