defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    factor_to_string = %{3 => "Pling", 5 => "Plang", 7 => "Plong"}
    factors = [3, 5, 7]

    case factors |> Enum.filter(&(rem(number, &1) == 0)) do
      [] ->
        number |> Integer.to_string()

      accepted_factors ->
        accepted_factors |> Enum.map(&(factor_to_string |> Map.fetch!(&1))) |> List.to_string()
    end
  end
end
