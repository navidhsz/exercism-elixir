defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"aardvark" => "a", "ability" => "a", "ballast" => "b", "beauty" => "b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    keys = input |> Map.keys()
    _transform(input, keys)
  end

  defp _transform(input, keys, result \\ %{})
  defp _transform(input, [], result), do: result

  defp _transform(input, [h | t], result) do
    v = input[h]
    r = Enum.reduce(v, result, fn x, result -> result |> Map.put(x |> String.downcase(), h) end)
    _transform(input, t, r)
  end
end
