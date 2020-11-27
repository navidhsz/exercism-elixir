defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do

    find_rotated_char = fn
      ch, shift when ch + shift <= ?z and ch >= ?a and ch <= ?z -> ch + shift
      ch, shift when ch + shift <= ?Z and ch >= ?A and ch <= ?Z -> ch + shift
      ch, shift when ch + shift >= ?z and ch >= ?a and ch <= ?z -> ch + shift - ?z + ?a - 1
      ch, shift when ch + shift >= ?Z and ch >= ?A and ch <= ?Z -> ch + shift - ?Z + ?A - 1
      ch, shift -> ch
    end

    text
    |> String.to_charlist
    |> Enum.map(fn ch -> find_rotated_char.(ch, shift) end)
    |> List.to_string
  end

end
