defmodule Bob do
  def hey(input) do
    trimmed_input = input |> String.trim_trailing()

    cond do
      trimmed_input |> is_fine -> "Fine. Be that way!"
      trimmed_input |> is_sure -> "Sure."
      trimmed_input |> is_calm_down -> "Calm down, I know what I'm doing!"
      trimmed_input |> is_whoa_chill_out -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp is_sure(input) do
    String.ends_with?(input, "?") and
      (String.upcase(input) != input or !is_any_alphabet(input))
  end

  defp is_calm_down(input) do
    String.ends_with?(input, "?") and String.upcase(input) == input
  end

  defp is_whoa_chill_out(input) do
    (is_any_alphabet(input) or byte_size(input) > String.length(input)) and
      ((String.ends_with?(input, "!") and String.upcase(input) == input) or
         (!String.ends_with?(input, "!") and String.upcase(input) == input))
  end

  defp is_fine(input) do
    input |> String.trim_trailing("\t") |> String.trim_trailing("\n\r ")
    input == "" or String.trim_trailing(input, "\t") == ""
  end

  defp is_any_alphabet(input) do
    chars = input |> String.to_charlist()
    downcase_alphabet = ?a..?z
    upcase_alphabet = ?A..?Z

    is_alphabet = fn char ->
      downcase_alphabet |> Enum.member?(char) or upcase_alphabet |> Enum.member?(char)
    end

    chars |> Enum.any?(&is_alphabet.(&1))
  end
end
