defmodule Tournament do
  @left_pad 31
  @right_pad 3
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    valid_input = input |> get_valid_input()
    teams = valid_input |> get_all_teams()

    # convert list of team to all matches per team then, map matches to stats
    results =
      teams
      |> Enum.map(fn team ->
        {team, valid_input |> Enum.filter(&(&1 |> String.contains?(team)))}
      end)
      |> Enum.map(fn {team, match} -> {team, get_stats(team, match)} end)
      |> Enum.filter(fn {_team, stat} -> stat != :error end)
      |> Enum.map(fn {team, stats} ->
        {String.pad_trailing(team, @left_pad) <>
           "|" <>
           String.pad_leading(to_string(elem(stats, 0)), @right_pad) <>
           " |" <>
           String.pad_leading(to_string(elem(stats, 1)), @right_pad) <>
           " |" <>
           String.pad_leading(to_string(elem(stats, 2)), @right_pad) <>
           " |" <>
           String.pad_leading(to_string(elem(stats, 3)), @right_pad) <>
           " |" <>
           String.pad_leading(to_string(elem(stats, 4)), @right_pad), elem(stats, 4)}
      end)
      |> Enum.sort(&(elem(&1, 1) > elem(&2, 1)))
      |> Enum.map(&elem(&1, 0))
      |> Enum.join("\n")

    String.pad_trailing("Team", @left_pad) <>
      "|" <>
      String.pad_leading("MP", @right_pad) <>
      " |" <>
      String.pad_leading("W", @right_pad) <>
      " |" <>
      String.pad_leading("D", @right_pad) <>
      " |" <>
      String.pad_leading("L", @right_pad) <>
      " |" <>
      String.pad_leading("P", @right_pad) <>
      "\n" <>
      results
  end

  def get_stats(_team, matches, stats \\ {0, 0, 0, 0, 0})

  def get_stats(_team, [], stats), do: stats

  def get_stats(team, matches, stats) do
    [h | t] = matches
    match = h |> String.split(";")

    case match do
      [^team, _, "win"] -> get_stats(team, t, calc_stat("win", stats))
      [_, ^team, "win"] -> get_stats(team, t, calc_stat("loss", stats))
      [_, ^team, "loss"] -> get_stats(team, t, calc_stat("win", stats))
      [^team, _, "loss"] -> get_stats(team, t, calc_stat("loss", stats))
      [^team, _, "draw"] -> get_stats(team, t, calc_stat("draw", stats))
      [_, ^team, "draw"] -> get_stats(team, t, calc_stat("draw", stats))
    end
  end

  def calc_stat(result, stats) do
    mp = stats |> elem(0)
    w = stats |> elem(1)
    d = stats |> elem(2)
    l = stats |> elem(3)
    p = stats |> elem(4)

    case result do
      "win" -> {mp + 1, w + 1, d, l, p + 3}
      "loss" -> {mp + 1, w, d, l + 1, p}
      "draw" -> {mp + 1, w, d + 1, l, p + 1}
    end
  end

  def get_valid_input(input) do
    input
    |> Enum.filter(&(&1 != ""))
    |> Enum.filter(fn r ->
      match = r |> String.split(";")
      length(match) == 3 and valid_result?(Enum.at(match, 2))
    end)
  end

  def valid_result?(result) do
    case result do
      result when result in ["win", "loss", "draw"] -> true
      _ -> false
    end
  end

  def get_all_teams(input) do
    input
    |> Enum.flat_map(&(&1 |> String.split(";")))
    |> Enum.filter(&(&1 != "win" and &1 != "loss" and &1 != "draw"))
    |> Enum.uniq()
  end
end
