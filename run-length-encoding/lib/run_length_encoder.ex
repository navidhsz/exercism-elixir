defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    case string do
      string when string == "" ->
        ""

      _ ->
        [current_char | remaining_chars] = string |> String.codepoints()
        do_encoding(remaining_chars, current_char)
    end
  end

  def do_encoding(remaining_chars, current_char, cnt \\ 1, encoded \\ []) do
    [h | t] = remaining_chars

    case h do
      h when h != current_char and t == [] and cnt == 1 ->
        (encoded ++ [current_char, h]) |> List.to_string()

      h when h != current_char and t == [] and cnt > 1 ->
        (encoded ++ [Integer.to_string(cnt), current_char] ++ [h]) |> List.to_string()

      h when h == current_char and t == [] and cnt >= 1 ->
        (encoded ++ [Integer.to_string(cnt + 1), current_char]) |> List.to_string()

      h when h != current_char and cnt == 1 ->
        do_encoding(t, h, cnt, encoded ++ [current_char])

      h when h != current_char and cnt > 1 ->
        do_encoding(t, h, 1, encoded ++ [Integer.to_string(cnt), current_char])

      h when h == current_char ->
        do_encoding(t, h, cnt + 1, encoded)
    end
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    case string do
      string when string == "" ->
        ""

      _ ->
        do_decode(string, 0, "", "", string |> String.length())
    end
  end

  def do_decode(str, index \\ 0, number \\ "", decoded \\ "", len \\ 0)

  def do_decode(str, index, number, decoded, len) when index == len do
    decoded
  end

  def do_decode(str, index, number, decoded, len) do
    char = str |> String.at(index)

    case char |> Integer.parse() do
      {num, ""} ->
        do_decode(str, index + 1, number <> char, decoded, len)

      :error when index < len and number == "" ->
        do_decode(str, index + 1, "", decoded <> char, len)

      :error when index < len and number != "" ->
        do_decode(
          str,
          index + 1,
          "",
          decoded <> String.duplicate(char, elem(Integer.parse(number), 0)),
          len
        )
    end
  end
end
