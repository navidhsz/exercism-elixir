defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) do
    len = s |> String.length()

    case len do
      len when size <= 0 -> []
      len when size > len -> []
      len when size == len -> [s]
      _ -> [String.slice(s, 0, size)] ++ (String.slice(s, 1, len - 1) |> slices(size))
    end
  end

  defp x(s, size) do
    len = s |> String.length()
  end
end
