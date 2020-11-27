defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    #IO.puts rna
    codons = Regex.scan(~r/.../,rna) |> List.flatten
    proteins = get_proteins(codons)
      #Enum.map(codons, fn(x) -> convert_to_protein(x) end)


    result = proteins |> Enum.group_by(fn {x, y} -> x end, fn {x, y} -> y end)
    (case Map.has_key?(result,:error) do
      true -> {:error, "invalid RNA"}
      false -> Map.fetch(result,:ok)
    end)
  end

  defp get_proteins(codons) when codons == [] do
    []
  end

  defp get_proteins(codons) do
    [codon | tail] = codons
    [case convert_to_protein(codon) do
      {:ok, "STOP"} -> []
      {_, p} -> p
     end
    | get_proteins(tail)]
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """

  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    convert_to_protein(codon)
  end

  defp convert_to_protein(codeon) when codeon == "UGU" or codeon == "UGC" do
    {:ok, "Cysteine"}
  end

  defp convert_to_protein(codeon) when codeon == "UUA" or codeon == "UUG" do
    {:ok, "Leucine"}
  end

  defp convert_to_protein(codeon) when codeon == "AUG" do
    {:ok, "Methionine"}
  end

  defp convert_to_protein(codeon) when codeon == "UUU" or codeon == "UUC" do
    {:ok, "Phenylalanine"}
  end

  defp convert_to_protein(codeon) when codeon == "UCU" or codeon == "UCC" or codeon == "UCA" or codeon == "UCG" do
    {:ok, "Serine"}
  end

  defp convert_to_protein(codeon) when codeon == "UGG" do
    {:ok, "Tryptophan"}
  end

  defp convert_to_protein(codeon) when codeon == "UAU" or codeon == "UAC" do
    {:ok, "Tyrosine"}
  end

  defp convert_to_protein(codeon) when codeon == "UAA" or codeon == "UAG" or codeon == "UGA" do
    {:ok, "STOP"}
  end

  defp convert_to_protein(codeon) when length(codeon) == 3 do
    {:error, "invalid RNA"}
  end

  defp convert_to_protein(codeon) do
    {:error, "invalid codon"}
  end

end
