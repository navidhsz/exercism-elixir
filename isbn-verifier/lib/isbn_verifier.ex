defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    case convert(isbn) do
      :error ->
        false

      isbn_codepoints ->
        isbn_codepoints
        |> Enum.reverse()
        |> Enum.reduce({1, 0}, fn n, {i, result} ->
          {i + 1,
           case n do
             "X" -> 10 * i
             c -> elem(Integer.parse(c), 0) * i + result
           end}
        end)
        |> elem(1)
        |> rem(11) == 0
    end
  end

  def convert(isbn) do
    isbn_str = isbn |> String.split("-") |> Enum.join("")
    isbn_codepoints = isbn_str |> String.codepoints()
    len = isbn_str |> String.length()

    any_non_digit_index =
      isbn_codepoints
      |> Enum.find_index(fn n ->
        n != "0" and n != "1" and n != "2" and n != "3" and n != "4" and n != "5" and n != "6" and
          n != "7" and n != "8" and n != "9"
      end)

    any_non_digit_char =
      case any_non_digit_index do
        nil -> nil
        any_non_digit_index -> isbn_codepoints |> Enum.at(any_non_digit_index)
      end

    case len do
      10 when any_non_digit_index == nil ->
        isbn_str |> String.codepoints()

      10 when any_non_digit_char == "X" and any_non_digit_index == len - 1 ->
        isbn_str |> String.codepoints()

      _ ->
        :error
    end
  end
end
