defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  def frequency([], workers), do: %{}

  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    chars = texts |> Enum.join("") |> String.downcase() |> String.codepoints()

    n =
      case div(length(chars), workers) do
        n when n == 0 -> workers
        n -> n
      end

    chars
    |> Enum.chunk_every(n)
    |> Enum.map(&Task.async(fn -> Enum.frequencies(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(fn m1, m2 -> Map.merge(m1, m2, fn _k, v1, v2 -> v1 + v2 end) end)
    |> Enum.filter(fn {k, v} ->
      case k do
        k when k in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", " "] -> nil
        _ -> {k, v}
      end
    end)
    |> Enum.into(%{})
  end
end
