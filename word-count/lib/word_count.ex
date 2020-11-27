defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    tokens = Regex.scan(~r/[a-z0-9\-\p{L}]+/u, sentence |> String.downcase) |> List.flatten
    grouped_token = Enum.group_by(tokens, fn x -> x end, fn _x -> 1 end)
    unique_tokens = tokens |> Enum.uniq
    count_tokens(unique_tokens, grouped_token)
  end

  defp count_tokens(tokens,result) when tokens == [] do
    result
  end

  defp count_tokens(tokens,result) do
    [head | tail] = tokens
    {:ok, occurrence} = result |> Map.fetch(head)
    new_result = result |> Map.put(head, occurrence |> Enum.sum)
    count_tokens(tail, new_result)
  end

end
