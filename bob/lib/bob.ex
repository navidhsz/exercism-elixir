defmodule Bob do
  def hey(input) do
    length = input |> String.trim_trailing() |> String.length()

    cond do
      input |> is_sure -> "Sure."
      input |> is_calm_down -> "Calm down, I know what I'm doing!"
      input |> is_whoa_chill_out -> "Whoa, chill out!"
      input |> is_fine -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  defp is_fine(input) do
    is_all_space_or_tab(input)
  end

  defp is_sure(input) do
    is_last_char_question_mark(input) and not (is_any_char(input) and is_all_uppercase(input))
  end

  defp is_calm_down(input) do
    is_any_char(input) and is_all_uppercase(input) and is_last_char_question_mark(input)
  end

  defp is_whoa_chill_out(input) do
    is_all_uppercase(input) and not is_all_space_or_tab(input) and is_any_char(input)
  end

  ########## helper functions ###########

  defp is_all_space_or_tab(input) do
    input_length = input |> String.length()

    input == "" or
      case Regex.scan(~r/[[:space:]+]/, input) |> length do
        ^input_length -> true
        _ -> false
      end
  end

  defp is_last_char_dot(input) do
    length = input |> String.length()
    input |> String.at(length - 1) == "?"
  end

  defp is_all_uppercase(input) do
    not Regex.match?(~r/[[:lower:]]/, input)
  end

  defp is_any_char(input) do
    Regex.match?(~r/[[:alpha:]]/, input)
  end

  defp is_last_char_question_mark(input) do
    trimmed_input = input |> String.trim_trailing()
    length = trimmed_input |> String.length()
    trimmed_input |> String.at(length - 1) == "?"
  end
end
