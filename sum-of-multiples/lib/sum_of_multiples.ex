defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    1..(limit - 1)
    |> Enum.to_list()
    |> Enum.filter(fn n -> is_multiple_of_factor(n, factors) end)
    |> Enum.reduce(0, fn n, acc -> n + acc end)
  end

  defp is_multiple_of_factor(number, factors) when factors == [] do
    false
  end

  defp is_multiple_of_factor(number, factors) do
    [h | t] = factors
    r = rem(number, h)

    case r do
      0 -> true
      _ -> is_multiple_of_factor(number, t)
    end
  end
end
