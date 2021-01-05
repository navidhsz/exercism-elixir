defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    upper_part = create_diamond(letter)
    lower_part = tl(upper_part |> Enum.reverse())
    (upper_part ++ lower_part) |> List.to_string()
  end

  def create_diamond(letter, current_letter \\ ?A, diamond \\ [])

  def create_diamond(letter, current_letter, diamond) when current_letter > letter do
    diamond
  end

  def create_diamond(letter, current_letter, diamond) do
    n = (letter - ?A) * 2 + 1
    middle = div(n, 2)
    start_index = middle + (current_letter - ?A)
    end_index = middle - (current_letter - ?A)
    diamond = diamond ++ [create_row(current_letter, start_index, end_index, n - 1)]
    create_diamond(letter, current_letter + 1, diamond)
  end

  def create_row(letter, start_index, end_index, current_index, result \\ "")

  def create_row(letter, start_index, end_index, -1, result) do
    result <> "\n"
  end

  def create_row(?A, start_index, end_index, current_index, result)
      when start_index == current_index do
    create_row(?A, start_index, end_index, current_index - 1, "A" <> result)
  end

  def create_row(?A, start_index, end_index, current_index, result)
      when start_index == current_index do
    create_row(?A, start_index, end_index, current_index - 1, " " <> result)
  end

  def create_row(letter, start_index, end_index, current_index, result)
      when start_index == current_index or end_index == current_index do
    create_row(
      letter,
      start_index,
      end_index,
      current_index - 1,
      List.to_string([letter]) <> result
    )
  end

  def create_row(letter, start_index, end_index, current_index, result) do
    create_row(letter, start_index, end_index, current_index - 1, " " <> result)
  end
end
