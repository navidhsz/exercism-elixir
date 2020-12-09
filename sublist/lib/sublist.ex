defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    cond do
      a === b -> :equal
      length(a) > length(b) -> check_status(a, b, :superlist)
      length(a) < length(b) -> check_status(b, a, :sublist)
      true -> :unequal
    end
  end

  defp check_status(a, b, status) do
    slice =
      a
      |> Enum.slice(0, length(b))

    [h | t] = a

    cond do
      slice === b -> status
      t == [] -> :unequal
      length(t) < length(b) -> :unequal
      true -> check_status(t, b, status)
    end
  end
end
