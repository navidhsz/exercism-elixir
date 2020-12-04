defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(map, String.t(), integer) :: map
  def add(db, name, grade) do
    db |> Map.update(grade, [name], fn current_names -> current_names ++ [name] end)
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(map, integer) :: [String.t()]
  def grade(db, grade) do
    case db |> Map.fetch(grade) do
      {:ok, result} -> result
      _ -> []
    end
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(map) :: [{integer, [String.t()]}]
  def sort(db) do
    db
    |> Map.keys()
    |> Enum.sort()
    |> Enum.map(fn g -> {g, db |> Map.fetch!(g) |> Enum.sort()} end)
  end
end
