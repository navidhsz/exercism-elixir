defmodule Say do
  @numberToEnglish %{
    0 => "zero",
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) do
    cond do
      number == 0 ->
        @numberToEnglish
        |> Map.fetch(number)

      number < 0 or number >= 1_000_000_000_000 ->
        {:error, "number is out of range"}

      true ->
        {:ok, convert_to_english(number)}
    end
  end

  def convert_to_english(number) when number >= 1 and number <= 9 do
    @numberToEnglish
    |> Map.fetch!(number)
  end

  def convert_to_english(number) when number >= 10 and number <= 99 do
    q = div(number, 10)

    case rem(number, 10) do
      r when r == 0 or q == 1 ->
        @numberToEnglish
        |> Map.fetch!(number)

      r ->
        Map.fetch!(@numberToEnglish, div(number, 10) * 10) <>
          "-" <> Map.fetch!(@numberToEnglish, r)
    end
  end

  def convert_to_english(number) when number >= 100 and number <= 999 do
    q = div(number, 100)

    case rem(number, 100) do
      r when r == 0 -> Map.fetch!(@numberToEnglish, q) <> " hundred"
      _ -> Map.fetch!(@numberToEnglish, q) <> " hundred " <> convert_to_english(number - q * 100)
    end
  end

  def convert_to_english(number) do
    {divisor, n} =
      case number do
        number when number >= 1_000 and number <= 999_999 ->
          {:math.pow(10, 3) |> round, "thousand"}

        number when number >= 1_000_000 and number <= 999_999_999 ->
          {:math.pow(10, 6) |> round, "million"}

        number when number >= 1_000_000_000 and number <= 999_999_999_999 ->
          {:math.pow(10, 9) |> round, "billion"}
      end

    q = div(number, divisor)

    case rem(number, divisor) do
      r when r == 0 ->
        convert_to_english(q) <> " " <> n

      _r when q != 0 ->
        convert_to_english(q) <> " " <> n <> " " <> convert_to_english(number - q * divisor)

      _ ->
        ""
    end
  end
end
