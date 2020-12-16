defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) do
    find_hamming_dist(strand1, strand2)
  end

  def find_hamming_dist(strand1, strand2, diff \\ 0)

  def find_hamming_dist(strand1, strand2, diff) when strand1 == '' and strand2 == '' do
    {:ok, diff}
  end

  def find_hamming_dist(strand1, strand2, diff) do
    [h1 | t1] = strand1
    [h2 | t2] = strand2

    cond do
      length(strand1) != length(strand2) -> {:error, "Lists must be the same length"}
      h1 != h2 and t1 != [] -> find_hamming_dist(t1, t2, diff + 1)
      h1 != h2 -> {:ok, diff + 1}
      h1 == h2 and t1 != [] -> find_hamming_dist(t1, t2, diff)
      h1 == h2 -> {:ok, diff}
    end
  end
end
