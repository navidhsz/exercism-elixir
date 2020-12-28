defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """
  @spec convert(list, integer, integer) :: list | nil
  def convert(digits, base_a, base_b) when base_a <= 1 or base_b <= 1 or digits == [] do
    nil
  end

  def convert(digits, base_a, 10) do
    case valid?(digits, base_a) do
      false ->
        nil

      true ->
        digits
        |> Enum.reverse()
        |> Enum.reduce({0, 0}, fn n, {i, r} ->
          {i + 1, r + n * round(:math.pow(base_a, i))}
        end)
        |> elem(1)
        |> Integer.digits()
    end
  end

  def convert(digits, base_a, base_b) do
    case convert(digits, base_a, 10) |> Integer.undigits() do
      nil -> nil
      base_ten -> do_convert(base_ten, base_b)
    end
  end

  def valid?(digits, base) do
    Enum.all?(digits, fn n -> n < base end) and Enum.all?(digits, fn n -> n >= 0 end)
  end

  def do_convert(base_ten, to_base, result \\ []) do
    q = div(base_ten, to_base)
    r = rem(base_ten, to_base)

    case q do
      q when q == 0 -> [base_ten] ++ result
      _ -> do_convert(q, to_base, [r] ++ result)
    end
  end
end
