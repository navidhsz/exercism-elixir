defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples
  iex> Transpose.transpose("ABC\nDE")
  "AD\nBE\nC"

  iex> Transpose.transpose("AB\nDEF")
  "AD\nBE\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(""), do: ""

  def transpose(input) do
    split =
      input |> String.split("\n") |> pre_process() |> Enum.map(fn n -> String.codepoints(n) end)

    size = split |> Enum.at(0) |> length()
    _transpose(split, 0, size)
  end

  def _transpose(input, cnt, cnt_max, result \\ [])

  def _transpose(input, cnt, cnt_max, result) when cnt == cnt_max,
    do: result |> Enum.join("\n") |> String.trim()

  def _transpose(input, cnt, cnt_max, result) do
    r = input |> Enum.reduce("", fn n, acc -> acc <> Enum.at(n, cnt) end)
    _transpose(input, cnt + 1, cnt_max, result ++ [r])
  end

  defp pre_process(input) do
    max_size = input |> Enum.map(&String.length(&1)) |> Enum.max()
    input |> Enum.map(&String.pad_trailing(&1, max_size))
  end
end
