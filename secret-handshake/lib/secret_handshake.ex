defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    handshakes = [{1, "wink"}, {2, "double blink"}, {4, "close your eyes"}, {8, "jump"}]
    should_reverse = is_bit_set(code, 16)

    result =
      handshakes
      |> Enum.filter(fn {bit, _str} -> is_bit_set(code, bit) end)
      |> Enum.map(fn {_bit, str} -> str end)

    case should_reverse do
      true -> result |> Enum.reverse()
      false -> result
    end
  end

  defp is_bit_set(code, bit) do
    use Bitwise
    r = code &&& bit

    case r do
      1 -> true
      2 -> true
      4 -> true
      8 -> true
      16 -> true
      0 -> false
    end
  end
end
