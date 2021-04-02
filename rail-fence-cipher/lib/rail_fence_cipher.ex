defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    case str do
      str when str == "" or rails == 1 ->
        str

      _ ->
        chars = str |> String.codepoints()
        matrix = get_matrix(rails)

        fill_encoded_matrix(chars, rails, {1, "INC"}, matrix)
        |> Map.values()
        |> List.flatten()
        |> Enum.join("")
    end
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  def decode(str, 1), do: str

  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    chars = str |> String.codepoints()
    matrix = get_matrix(rails)
    new_matrix = fill_encoded_matrix(chars, rails, {1, "INC"}, matrix)
    filled_matrix = fill_decoded_matrix(chars, rails, 1, new_matrix)
    traverse_matrix(length(chars), filled_matrix, rails, {1, "INC"})
  end

  def traverse_matrix(len, filled_matrix, rails, cnt, result \\ [])

  def traverse_matrix(len, filled_matrix, rails, cnt, result) do
    {counter, _} = cnt
    row = filled_matrix[counter]

    case row do
      ^row when len == length(result) ->
        result |> Enum.join("")

      [] ->
        traverse_matrix(len, filled_matrix, rails, get_next_row(rails, cnt), result)

      [h | []] ->
        traverse_matrix(
          len,
          %{filled_matrix | counter => []},
          rails,
          get_next_row(rails, cnt),
          result ++ [h]
        )

      [h | t] ->
        traverse_matrix(
          len,
          %{filled_matrix | counter => t},
          rails,
          get_next_row(rails, cnt),
          result ++ [h]
        )
    end
  end

  def fill_decoded_matrix(chars, rails, cnt, matrix) when cnt == rails + 1, do: matrix

  def fill_decoded_matrix(chars, rails, cnt, matrix) do
    row = matrix[cnt]
    len = length(row)
    {r1, r2} = chars |> Enum.split(len)

    fill_decoded_matrix(r2, rails, cnt + 1, %{matrix | cnt => r1})
  end

  def fill_encoded_matrix([], rails, cnt, matrix), do: matrix

  def fill_encoded_matrix(chars, rails, cnt, matrix) do
    [h | t] = chars
    {counter, _} = cnt
    row = matrix[counter]
    fill_encoded_matrix(t, rails, get_next_row(rails, cnt), %{matrix | counter => row ++ [h]})
  end

  defp get_next_row(rails, cnt) do
    case cnt do
      {row, direction} when row == rails and direction == "INC" -> {row - 1, "DEC"}
      {row, direction} when row == 1 and direction == "DEC" -> {row + 1, "INC"}
      {row, direction} when row < rails and direction == "INC" -> {row + 1, direction}
      {row, direction} when row > 1 and direction == "DEC" -> {row - 1, direction}
    end
  end

  defp get_matrix(rails, matrix \\ %{})
  defp get_matrix(0, matrix), do: matrix

  defp get_matrix(rails, matrix) do
    get_matrix(rails - 1, Map.put_new(matrix, rails, []))
  end
end
