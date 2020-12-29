defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @map %{
    1 => :monday,
    2 => :tuesday,
    3 => :wednesday,
    4 => :thursday,
    5 => :friday,
    6 => :saturday,
    7 => :sunday
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    range =
      case month do
        2 -> 1..28
        month when month in [1, 3, 5, 7, 8, 10, 12] -> 1..31
        month when month in [4, 6, 9, 11] -> 1..30
      end
      |> Enum.to_list()

    first_day = find_day(year, month, weekday, range)

    case schedule do
      :first -> Date.new(year, month, first_day)
      :second -> Date.new(year, month, first_day + 7)
      :third -> Date.new(year, month, first_day + 14)
      :fourth -> Date.new(year, month, find_fourth(first_day, month))
      :last -> Date.new(year, month, find_last(first_day, month))
      :teenth -> Date.new(year, month, find_teenth(first_day))
    end
    |> elem(1)
  end

  defp find_teenth(first_day) do
    case first_day do
      first_day when div(first_day + 14, 10) == 1 -> first_day + 14
      first_day when div(first_day + 7, 10) == 1 -> first_day + 7
    end
  end

  defp find_fourth(first_day, month) do
    case first_day do
      first_day when month in [1, 3, 5, 7, 8, 10, 12] and first_day + 21 > 31 -> first_day + 14
      first_day when month in [4, 6, 9, 11] and first_day + 21 > 31 -> first_day + 14
      first_day when month == 2 and first_day + 21 > 28 -> first_day + 14
      _ -> first_day + 21
    end
  end

  defp find_last(first_day, month) do
    case first_day do
      first_day when month in [1, 3, 5, 7, 8, 10, 12] and first_day + 28 > 31 -> first_day + 21
      first_day when month in [1, 3, 5, 7, 8, 10, 12] and first_day + 28 <= 31 -> first_day + 28
      first_day when month in [1, 3, 5, 7, 8, 10, 12] and first_day + 21 > 31 -> first_day + 14
      first_day when month in [1, 3, 5, 7, 8, 10, 12] and first_day + 21 <= 31 -> first_day + 21
      first_day when month in [4, 6, 9, 11] and first_day + 28 > 30 -> first_day + 21
      first_day when month in [4, 6, 9, 11] and first_day + 28 <= 30 -> first_day + 28
      first_day when month in [4, 6, 9, 11] and first_day + 21 > 30 -> first_day + 14
      first_day when month in [4, 6, 9, 11] and first_day + 21 <= 30 -> first_day + 21
      first_day when month == 2 and first_day + 21 > 28 -> first_day + 14
      first_day when month == 2 and first_day + 21 <= 28 -> first_day + 21
    end
  end

  defp find_day(year, month, weekday, range) do
    [h | t] = range
    day = Calendar.ISO.day_of_week(year, month, h)
    current_weekday = @map |> Map.fetch!(day)

    case current_weekday do
      ^weekday -> h
      _ -> find_day(year, month, weekday, t)
    end
  end
end
