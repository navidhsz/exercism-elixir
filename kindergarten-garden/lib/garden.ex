defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @default_student_names [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]

  @plant_names %{"G" => :grass, "C" => :clover, "R" => :radishes, "V" => :violets}

  @spec info(String.t(), list) :: map
  def info(info_string), do: info(info_string, @default_student_names)

  def info(info_string, student_names) do
    sorted_students_name = student_names |> Enum.sort()
    {ready_input, size} = pre_process(info_string)
    result_template = get_result_template(sorted_students_name)
    process(ready_input, size, sorted_students_name, sorted_students_name, result_template)
  end

  defp pre_process(info_string) do
    str = info_string |> String.split("\n") |> Enum.map(&String.codepoints(&1))
    {str, str |> Enum.at(0) |> length}
  end

  defp get_result_template([h | t], result_template \\ %{}) do
    case t do
      [] -> result_template |> Map.put(h, {})
      _ -> get_result_template(t, result_template |> Map.put(h, {}))
    end
  end

  defp find_index(student_names, name) do
    2 * (student_names |> Enum.find_index(&(&1 == name)))
  end

  defp process(str, size, student_names, original_student_names, result)
  defp process(_str, _size, [], _original_student_names, result), do: result
  defp process(_str, 0, _student_name, _original_student_names, result), do: result
  defp process(_str, 0, [], _original_student_names, result), do: result

  defp process(str, size, student_names, original_student_names, result) do
    [h | t] = student_names
    start_index = find_index(original_student_names, h)
    plant1 = @plant_names |> Map.fetch!(Enum.at(str, 0) |> Enum.at(start_index))
    plant2 = @plant_names |> Map.fetch!(Enum.at(str, 0) |> Enum.at(start_index + 1))
    plant3 = @plant_names |> Map.fetch!(Enum.at(str, 1) |> Enum.at(start_index))
    plant4 = @plant_names |> Map.fetch!(Enum.at(str, 1) |> Enum.at(start_index + 1))

    process(str, size - 2, t, original_student_names, %{
      result
      | h => {plant1, plant2, plant3, plant4}
    })
  end
end
