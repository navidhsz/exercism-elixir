defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    codepoints = string |> String.reverse() |> String.codepoints()
    valid? = codepoints |> Enum.all?(fn n -> n == "1" or n == "0" end)

    case valid? do
      false ->
        0

      true ->
        codepoints
        |> Enum.reduce({0, 0}, fn x, {acc, index} ->
          d = x |> Integer.parse() |> elem(0)
          {acc + d * :math.pow(2, index), index + 1}
        end)
        |> elem(0)
    end
  end
end
