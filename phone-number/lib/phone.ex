defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw) do
    digits =
      raw
      |> String.codepoints()
      |> Enum.filter(fn n ->
        n != " " and n != "(" and n != ")" and n != "-" and n != "." and n != "+"
      end)

    is_all_digits = is_remaining_digit(digits)
    len = length(digits)
    [h | t] = digits

    cond do
      is_all_digits == false -> "0000000000"
      len == 11 and h == "1" and hd(t) != "0" and hd(t) != "1" -> check_exchange_code(t)
      len == 10 and h != "0" and h != "1" -> check_exchange_code(digits)
      true -> "0000000000"
    end
  end

  defp check_exchange_code(digits) do
    exchange_code = digits |> Enum.at(3)

    case exchange_code do
      exchange_code when exchange_code == "0" or exchange_code == "1" -> "0000000000"
      _ -> digits |> List.to_string()
    end
  end

  defp is_remaining_digit(digits) do
    is_number = fn n ->
      n == "0" or n == "1" or n == "2" or n == "3" or n == "4" or n == "5" or n == "6" or n == "7" or
        n == "8" or n == "9"
    end

    [h | t] = digits
    is_number = is_number.(h)

    case h do
      h when is_number and t != [] -> is_remaining_digit(t)
      h when is_number and t == [] -> true
      _ -> false
    end
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw) do
    phone_number = raw |> number()
    [n1, n2, n3 | t] = phone_number |> String.codepoints()

    case phone_number do
      "0000000000" -> "000"
      _ -> n1 <> n2 <> n3
    end
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    [n1, n2, n3, n4, n5, n6, n7, n8, n9, n10 | t] = raw |> number() |> String.codepoints()
    "(#{n1}#{n2}#{n3}) #{n4}#{n5}#{n6}-#{n7}#{n8}#{n9}#{n10}"
  end
end
