defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str |> String.codepoints() |> check
  end

  defp is_match(open_bracket, close_bracket) do
    (open_bracket == "(" and close_bracket == ")") or
      (open_bracket == "[" and close_bracket == "]") or
      (open_bracket == "{" and close_bracket == "}")
  end

  defp check(chars, stack \\ [])

  defp check(chars, stack) when chars == [] and stack == [] do
    true
  end

  defp check(chars, stack) when chars == [] and stack != [] do
    false
  end

  defp check(chars, stack) do
    [h | t] = chars

    cond do
      h == "(" or h == "[" or h == "{" ->
        check(t, [h] ++ stack)

      (h == ")" or h == "]" or h == "}") and stack == [] ->
        false

      (h == ")" or h == "]" or h == "}") and stack != [] ->
        is_match(hd(stack), h) && check(t, tl(stack))

      true ->
        check(t, stack)
    end
  end
end
