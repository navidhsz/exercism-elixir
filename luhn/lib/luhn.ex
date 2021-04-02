defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) when number in [0, 1], do: false

  def valid?(number) do
    digits = number |> String.codepoints() |> Enum.filter(&(&1 != " "))
    valid_length?(digits) and valid_digits?(digits) and valid_luhn?(digits)
  end

  defp valid_luhn?(digits) do
    digits
    |> Enum.reverse()
    |> Enum.map(&elem(Integer.parse(&1), 0))
    |> Enum.with_index()
    |> Enum.map(fn {n, i} -> get_luhn_digit(n, i) end)
    |> Enum.reduce(&(&1 + &2))
    |> rem(10) == 0
  end

  defp get_luhn_digit(n, i) do
    r = rem(i, 2)

    case i do
      _i when r != 0 and n * 2 > 9 ->
        n * 2 - 9

      _i when r != 0 ->
        n * 2

      _ ->
        n
    end
  end

  defp valid_length?(digits) do
    case digits do
      digits when length(digits) <= 1 -> false
      _ -> true
    end
  end

  def valid_digits?(digits) do
    digits
    |> Enum.filter(
      &(&1 == "0" or
          &1 == "1" or
          &1 == "2" or
          &1 == "3" or
          &1 == "4" or
          &1 == "5" or
          &1 == "6" or
          &1 == "7" or
          &1 == "8" or
          &1 == "9")
    )
    |> length() == length(digits)
  end
end
