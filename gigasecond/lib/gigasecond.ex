defmodule Gigasecond do
  @ten_billion_seconds round(:math.pow(10, 9))

  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  def from({{year, month, day}, {hours, minutes, seconds}}) do
    padded_month = get_padded(month)
    padded_day = get_padded(day)
    padded_hour = get_padded(hours)
    padded_min = get_padded(minutes)
    padded_sec = get_padded(seconds)

    {:ok, date_time} =
      NaiveDateTime.from_iso8601(
        "#{year}-#{padded_month}-#{padded_day} #{padded_hour}:#{padded_min}:#{padded_sec}"
      )

    d = NaiveDateTime.add(date_time, @ten_billion_seconds)

    {{d.year, d.month, d.day}, {d.hour, d.minute, d.second}}
  end

  def get_padded(param) do
    case param do
      param when param in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] -> "0#{param}"
      _ -> "#{param}"
    end
  end
end
