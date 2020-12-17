defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    create_verse(number)
  end

  defp create_verse(
         number,
         common_template \\ "NUMBER_BOTTLE of beer on the wall, NUMBER_BOTTLE of beer.\nTake TAKE_NUM down and pass it around, "
       )

  defp create_verse(number, common_template) when number > 2 do
    (String.replace(common_template, "NUMBER_BOTTLE", to_string(number) <> " bottles")
     |> String.replace("TAKE_NUM", "one")) <>
      "#{to_string(number - 1)} bottles of beer on the wall.\n"
  end

  defp create_verse(number, common_template) when number == 1 do
    (String.replace(common_template, "NUMBER_BOTTLE", "1 bottle")
     |> String.replace("TAKE_NUM", "it")) <> "no more bottles of beer on the wall.\n"
  end

  defp create_verse(number, common_template) when number == 2 do
    (String.replace(common_template, "NUMBER_BOTTLE", "2 bottles")
     |> String.replace("TAKE_NUM", "one")) <> "1 bottle of beer on the wall.\n"
  end

  defp create_verse(number, _common_template) when number == 0 do
    """
    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range) do
    range |> Enum.map(&verse(&1)) |> Enum.join("\n")
  end

  def lyrics() do
    lyrics(99..0)
  end
end
