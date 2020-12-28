defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number > 64 or number <= 0 do
    {:error, "The requested square must be between 1 and 64 (inclusive)"}
  end

  def square(number) do
    {:ok, :math.pow(2, number - 1) |> round}
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    {:ok,
     1..64
     |> Enum.map(fn n -> elem(square(n), 1) end)
     |> Enum.reduce(fn n, acc -> n + acc end)}
  end
end
