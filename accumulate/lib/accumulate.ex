defmodule Accumulate do
  @doc """
    Given a list and a function, apply the function to each list item and
    replace it with the function's return value.

    Returns a list.

    ## Examples

      iex> Accumulate.accumulate([], fn(x) -> x * 2 end)
      []

      iex> Accumulate.accumulate([1, 2, 3], fn(x) -> x * 2 end)
      [2, 4, 6]

  """
  def accumulate(list, fun) when list == [] do
     list
  end

  @spec accumulate(list, (any -> any)) :: list
  def accumulate(list, fun) do
    [head | tail] = list
    [fun.(head) | accumulate(tail, fun)]
  end


end
