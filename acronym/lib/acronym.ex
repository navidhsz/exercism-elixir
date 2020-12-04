defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    get_acronym_char = fn word ->
      first_char =
        case word |> String.at(0) do
          nil -> ""
          ch -> ch
        end

      case Regex.scan(~r{[[:upper:]]}, word) do
        [[c1], [c2]] -> first_char <> c2
        _ -> first_char
      end
    end

    string
    |> String.split([" ", "-", "_"])
    |> Enum.map(fn w -> get_acronym_char.(w) end)
    |> List.to_string()
    |> String.upcase()
  end
end
