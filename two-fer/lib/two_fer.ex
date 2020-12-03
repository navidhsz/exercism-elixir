defmodule TwoFer do
  @doc """
  Two-fer or 2-fer is short for two for one. One for you and one for me.
  """
  @spec two_fer(String.t()) :: String.t()
  def two_fer(name) do
    cond do
      name |> String.valid?() -> "One for " <> name <> ", one for me"
      true -> raise FunctionClauseError
    end
  end

  def two_fer() do
    "One for you, one for me"
  end
end
