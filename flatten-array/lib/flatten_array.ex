defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    list
    |> do_flatten()
  end

  defp do_flatten(list) when list == [] do
    []
  end

  defp do_flatten(list) when is_list(list) and list != [] do
    [h | t] = list

    cond do
      !is_list(h) and !is_nil(h) -> [h] ++ do_flatten(t)
      !is_list(h) and is_nil(h) -> [] ++ do_flatten(t)
      is_list(h) -> do_flatten(h) ++ do_flatten(t)
    end
  end
end
