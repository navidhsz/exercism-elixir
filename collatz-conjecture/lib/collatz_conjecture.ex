defmodule CollatzConjecture do
  import Integer

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) do
    input |> collatz_conjecture
  end

  defp collatz_conjecture(input, step \\ 0) do
    case input do
      0 ->
        raise FunctionClauseError, message: "zero is an error"

      input when input < 0 ->
        raise FunctionClauseError, message: "negative value is an error"

      input when not is_number(input) ->
        raise FunctionClauseError, message: "string as input value is an error"

      1 ->
        step

      input when is_even(input) ->
        collatz_conjecture(div(input, 2), step + 1)

      input when is_odd(input) ->
        collatz_conjecture(3 * input + 1, step + 1)
    end
  end
end
