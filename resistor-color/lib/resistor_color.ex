defmodule ResistorColor do
  @moduledoc false

  @colorsToCodeMap [
    {:black, 0},
    {:brown, 1},
    {:red, 2},
    {:orange, 3},
    {:yellow, 4},
    {:green, 5},
    {:blue, 6},
    {:violet, 7},
    {:grey, 8},
    {:white, 9}
  ]

  @spec colors() :: list(String.t())
  def colors do
    Enum.map(Keyword.keys(@colorsToCodeMap), fn(k) -> Atom.to_string(k) end)
  end

  @spec code(String.t()) :: integer()
  def code(color) do
    @colorsToCodeMap[String.to_atom(color)]
  end

end
