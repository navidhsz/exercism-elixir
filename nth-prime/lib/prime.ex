defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) do
    case count do
      0 -> raise ArgumentError
      _ -> count |> find_nth()
    end
  end

  defp find_nth(count, cnt \\ 1) do
    is_prime = is_prime(cnt)

    case is_prime do
      true when count == 1 -> cnt
      true when count > 1 -> find_nth(count - 1, cnt + 1)
      false -> find_nth(count, cnt + 1)
    end
  end

  defp is_prime(number, cnt \\ 2) do
    r = rem(number, cnt)

    case number do
      1 -> false
      number when r == 0 and cnt < number -> false
      number when r == 0 and cnt == number -> true
      number when r != 0 and cnt < number -> is_prime(number, cnt + 1)
    end
  end
end
