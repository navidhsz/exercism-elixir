defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count(charlist(), char()) :: non_neg_integer()
  def count(strand, nucleotide) do
    counter = fn (x, acc) ->
      case x do
        ^nucleotide -> acc + 1
        _ -> acc
      end
    end

    Enum.reduce(strand, 0, fn x, acc -> counter.(x, acc) end)
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram(charlist()) :: map()
  def histogram(strand) do
    create_hg(strand)
  end

  def create_hg(strand) when strand == '' do
    %{?A => 0, ?T => 0, ?C => 0, ?G => 0}
  end

  def create_hg(strand, hg \\ %{?A => 0, ?T => 0, ?C => 0, ?G => 0}) do
    [head | tail] = strand
    {:ok, val} = hg
                 |> Map.fetch(head)
    new_hg = hg
             |> Map.put(head, val + 1)
    case tail do
      [] -> new_hg
      _ -> create_hg(tail, new_hg)
    end
  end
end
