defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    products = get_products(max_factor, min_factor)
    palindromes = products |> Enum.filter(&palindrome?(&1))
    min_palindrome = palindromes |> List.first()
    max_palindrome = palindromes |> List.last()

    min_factors =
      get_factors(min_palindrome, max_factor, min_factor)
      |> Enum.map(&(&1 |> Enum.sort()))
      |> Enum.uniq()

    max_factors =
      get_factors(max_palindrome, max_factor, min_factor)
      |> Enum.map(&(&1 |> Enum.sort()))
      |> Enum.uniq()

    %{
      min_palindrome => min_factors,
      max_palindrome => max_factors
    }
  end

  def get_factors(number, max, cnt \\ 1, result \\ [])

  def get_factors(number, max, cnt, result) when cnt >= max or cnt > div(number, 2), do: result

  def get_factors(number, max, cnt, result) do
    d = div(number, cnt)
    r = rem(number, cnt)

    case r do
      r when r == 0 and d <= max -> get_factors(number, max, cnt + 1, result ++ [[cnt, d]])
      _ -> get_factors(number, max, cnt + 1, result)
    end
  end

  def get_products(max_factor, min_factor) do
    range = min_factor..max_factor |> Enum.to_list()

    range
    |> Enum.flat_map(fn n -> Enum.map(range, &(&1 * n)) end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def palindrome?(number) do
    reverse = Integer.digits(number) |> Enum.reverse() |> Enum.join("") |> Integer.parse()

    case reverse do
      {reverse_num, ""} when reverse_num == number -> true
      _ -> false
    end
  end
end
