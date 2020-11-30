defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    lowercase_sentence = sentence |> String.downcase
    tokens = Regex.scan(~r/[[:alnum:]-]+/iu, lowercase_sentence) |> List.flatten
    grouped_token = Enum.group_by(tokens, fn x -> x end, fn _x -> 1 end)
    tokens |> Enum.uniq |> count_tokens(grouped_token)
  end

  defp count_tokens(tokens,result) when tokens == [] do
    result
  end

  defp count_tokens(tokens,result) do
    [head | tail] = tokens
    new_result = result |> Map.update!(head, &(&1 |> Enum.sum))
    count_tokens(tail, new_result)
  end

end
