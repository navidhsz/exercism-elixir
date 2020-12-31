defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @map %{
    [" _ ", "| |", "|_|", "   "] => "0",
    ["   ", "  |", "  |", "   "] => "1",
    [" _ ", " _|", "|_ ", "   "] => "2",
    [" _ ", " _|", " _|", "   "] => "3",
    ["   ", "|_|", "  |", "   "] => "4",
    [" _ ", "|_ ", " _|", "   "] => "5",
    [" _ ", "|_ ", "|_|", "   "] => "6",
    [" _ ", "  |", "  |", "   "] => "7",
    [" _ ", "|_|", "|_|", "   "] => "8",
    [" _ ", "|_|", " _|", "   "] => "9"
  }

  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, charlist()}
  def convert(input) do
    case get_matrix_size_status(input) do
      {:ok, 3, 4} -> find_number(input)
      {:ok, _, 4} -> extract_horizontally(input)
      {:ok, _, _} -> extract_vertically(input)
      error -> error
    end
  end

  defp extract_vertically([in1, in2, in3, in4 | t], result \\ "") do
    result = result <> elem(extract_horizontally([in1, in2, in3, in4]), 1)

    case t do
      [] -> {:ok, result}
      _ -> extract_vertically(t, result <> ",")
    end
  end

  defp extract_horizontally(input, result \\ "") do
    {sec1, rest1} = input |> Enum.at(0) |> String.split_at(3)
    {sec2, rest2} = input |> Enum.at(1) |> String.split_at(3)
    {sec3, rest3} = input |> Enum.at(2) |> String.split_at(3)
    {sec4, rest4} = input |> Enum.at(3) |> String.split_at(3)
    result = result <> elem(find_number([sec1, sec2, sec3, sec4]), 1)

    case {rest1, rest2, rest3, rest4} do
      {"", "", "", ""} -> {:ok, result}
      _ -> extract_horizontally([rest1, rest2, rest3, rest4], result)
    end
  end

  defp find_number(input) do
    case @map |> Map.fetch(input) do
      :error -> {:ok, "?"}
      number -> number
    end
  end

  defp get_matrix_size_status(input) do
    len = length(input)
    row_len = input |> Enum.at(0) |> String.length()

    case input |> Enum.filter(fn x -> rem(String.length(x), 3) != 0 end) do
      [] when rem(len, 4) == 0 -> {:ok, row_len, len}
      [] when len != 4 -> {:error, 'invalid line count'}
      _ -> {:error, 'invalid column count'}
    end
  end
end
