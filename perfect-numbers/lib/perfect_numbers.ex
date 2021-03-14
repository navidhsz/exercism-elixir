defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) do
    case number do
      number when number <= 0 -> {:error, "Classification is only possible for natural numbers."}
      number when number == 1 -> {:ok, :deficient}
      _ -> _classify(number)
    end
  end

  def _classify(number) do
    range = 1..div(number, 2)

    aliquot_sum =
      range |> Stream.filter(&(rem(number, &1) == 0)) |> Enum.to_list() |> Enum.reduce(&(&1 + &2))

    case aliquot_sum do
      aliquot_sum when aliquot_sum == number -> {:ok, :perfect}
      aliquot_sum when aliquot_sum > number -> {:ok, :abundant}
      aliquot_sum when aliquot_sum < number -> {:ok, :deficient}
    end
  end
end
