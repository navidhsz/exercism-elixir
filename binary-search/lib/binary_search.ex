defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """
  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, key) do
    :not_found
  end

  def search(numbers, key) when tuple_size(numbers) == 1 do
    case numbers |> elem(0) do
      key -> {:ok, 0}
      _ -> :not_found
    end
  end

  def search(numbers, key) do
    size = tuple_size(numbers)
    do_search(numbers, key, 0, size - 1)
  end

  def do_search(numbers, key, start_index, end_index) do
    middle_index = ((end_index + start_index) / 2) |> round
    elem = numbers |> elem(middle_index)

    case elem do
      ^key ->
        {:ok, middle_index}

      elem when start_index == end_index ->
        :not_found

      elem when elem < key ->
        do_search(numbers, key, middle_index + 1, end_index)

      elem when elem > key ->
        do_search(numbers, key, start_index, middle_index - 1)

      _ ->
        :not_found
    end
  end
end
