defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    _factors_for(number)
  end

  def _factors_for(number, divisor \\ 2, factors \\ [])

  def _factors_for(number, divisor, factors) when number < divisor, do: factors

  def _factors_for(number, divisor, factors) do
    q = rem(number, divisor)
    d = div(number, divisor)

    case q do
      q when q == 0 -> _factors_for(d, divisor, factors ++ [divisor])
      q when q != 0 -> _factors_for(number, divisor + 1, factors)
    end
  end
end
