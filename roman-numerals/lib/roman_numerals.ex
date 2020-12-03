defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """

  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    number
    |> Integer.digits()
    |> find_numeral
  end

  # function header
  def find_numeral(numeral \\ "", digits)

  def find_numeral(numeral, digits) when digits == [] do
    numeral
  end

  def find_numeral(numeral, digits) do
    [h | t] = digits

    digit =
      h *
        (:math.pow(10, length(digits) - 1)
         |> round)

    (numeral <>
       cond do
         digit >= 1000 -> String.duplicate("M", h)
         digit == 900 -> "CM"
         digit >= 500 -> "D" <> String.duplicate("C", h - 5)
         digit == 400 -> "CD"
         digit >= 100 -> String.duplicate("C", h)
         digit == 90 -> "XC"
         digit >= 50 -> "L" <> String.duplicate("X", h - 5)
         digit == 40 -> "XL"
         digit >= 10 -> String.duplicate("X", h)
         digit == 9 -> "IX"
         digit >= 5 -> "V" <> String.duplicate("I", h - 5)
         digit == 4 -> "IV"
         digit >= 1 -> String.duplicate("I", h)
         # covers other numbers with zero digit(s)
         true -> ""
       end)
    |> find_numeral(t)
  end
end
