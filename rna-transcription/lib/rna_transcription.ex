defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) when dna != [] do
    charList = Enum.map(dna, fn (x) -> to_rna_char(x) end)
    Enum.concat(charList)
  end

  def to_rna_char(ch) do
    case ch do
      ?G -> 'C'
      ?C -> 'G'
      ?T -> 'A'
      ?A -> 'U'
    end
  end

end
