defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  # The algorithm uses greedy approach in its core which means it tries to use the biggest number as much as possible.
  # However sometimes we could achieve optimal result if we have used other combinations. To find about those combination we apply greedy
  # approach iteratively. In each iteration we remove the biggest number in the list of coins and compare the result of iterations and pick up the one with
  # minimum number of coins.
  # there is a caveat with the greedy part. This greedy algorithm does not detect right combination in some case such as test number 6.
  # on the test number 6 , it will consider using 10 twice which leads to "cannot change"

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) when target < 0, do: {:error, "cannot change"}
  def generate(coins, target) do
    desc_sorted_coins =
      coins
      |> Enum.sort(&(&1 >= &2))

    find_optimal_combination(desc_sorted_coins, target)
  end

  def find_optimal_combination(coins, target, optimal_combination \\ {:error, "cannot change"})
  def find_optimal_combination([], target, optimal_combination), do: optimal_combination

  def find_optimal_combination([h | t], target, optimal_combination) do
    len =
      case optimal_combination
           |> elem(0) do
        :error ->
          0

        :ok ->
          optimal_combination
          |> elem(1)
          |> length()
      end

    case greedy_lookup([h | t], target) do
      {:ok, possible_combination} when len == 0 ->
        find_optimal_combination(t, target, {:ok, possible_combination |> Enum.sort()})

      {:ok, possible_combination} when len > 0 ->
        find_optimal_combination(
          t,
          target,
          {:ok,
           get_current_optimal_combination(possible_combination, elem(optimal_combination, 1)) |> Enum.sort()}
        )

      {:error, _} ->
        find_optimal_combination(t, target, optimal_combination)
    end
  end

  def get_current_optimal_combination(possible_combination, optimal_combination) do
    len1 = length(possible_combination)
    len2 = length(optimal_combination)

    cond do
      len1 < len2 -> possible_combination
      true -> optimal_combination
    end
  end

  def greedy_lookup(coins, target, result \\ [])

  def greedy_lookup([], target, result) do
    case result do
      [] -> {:error, "cannot change"}
      result when target > 0 -> {:error, "cannot change"}
      result when target == 0 -> {:ok, result}
    end
  end

  def greedy_lookup([h | t], target, result) do
    q = div(target, h)
    r = rem(target, h)

    case h do
      ^target -> greedy_lookup(t, target - h, result ++ [h])
      h when target == 0 -> {:ok, result}
      h when q == 0 -> greedy_lookup(t, target, result)
      h when q > 0 and r == 0 -> {:ok, result ++ replicate(h, q)}
      h when q > 0 and r != 0 -> greedy_lookup(t, target - q * h, result ++ replicate(h, q))

    end
  end

  defp replicate(x, n), do: for(_ <- 1..n, do: x)
end
