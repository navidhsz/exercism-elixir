defmodule ScaleGenerator do
  @doc """
  Find the note for a given interval (`step`) in a `scale` after the `tonic`.

  "m": one semitone
  "M": two semitones (full tone)
  "A": augmented second (three semitones)

  Given the `tonic` "D" in the `scale` (C C# D D# E F F# G G# A A# B C), you
  should return the following notes for the given `step`:

  "m": D#
  "M": E
  "A": F
  """
  @spec step(scale :: list(String.t()), tonic :: String.t(), step :: String.t()) ::
          list(String.t())
  def step(scale, tonic, step) do
    upcase_tonic = tonic |> upcase()
    index = scale |> Enum.find_index(&(&1 == upcase_tonic))

    case step do
      "m" when index + 1 < 12 -> scale |> Enum.at(index + 1)
      "M" when index + 2 < 12 -> scale |> Enum.at(index + 2)
      "A" when index + 3 < 12 -> scale |> Enum.at(index + 3)
      "m" -> scale |> Enum.at(index + 1 - 12)
      "M" -> scale |> Enum.at(index + 2 - 12)
      "A" -> scale |> Enum.at(index + 3 - 12)
    end
  end

  @doc """
  The chromatic scale is a musical scale with thirteen pitches, each a semitone
  (half-tone) above or below another.

  Notes with a sharp (#) are a semitone higher than the note below them, where
  the next letter note is a full tone except in the case of B and E, which have
  no sharps.

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C C# D D# E F F# G G# A A# B C)
  """
  @spec chromatic_scale(tonic :: String.t()) :: list(String.t())
  def chromatic_scale(tonic \\ "C", all_tones \\ ~w(A A# B C C# D D# E F F# G G#)) do
    upcase_tonic = tonic |> upcase()
    index = all_tones |> Enum.find_index(&(&1 == upcase_tonic))
    find_chromatic_scale(all_tones, index) ++ [upcase_tonic]
  end

  defp find_chromatic_scale(all_tones, index, cnt \\ 0, result \\ [])
  defp find_chromatic_scale(all_tones, index, 12, result), do: result

  defp find_chromatic_scale(all_tones, index, cnt, result) do
    case index do
      11 ->
        find_chromatic_scale(all_tones, 0, cnt + 1, result ++ [Enum.at(all_tones, index)])

      _ ->
        find_chromatic_scale(all_tones, index + 1, cnt + 1, result ++ [Enum.at(all_tones, index)])
    end
  end

  @doc """
  Sharp notes can also be considered the flat (b) note of the tone above them,
  so the notes can also be represented as:

  A Bb B C Db D Eb E F Gb G Ab

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C Db D Eb E F Gb G Ab A Bb B C)
  """
  @spec flat_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def flat_chromatic_scale(tonic \\ "C") do
    chromatic_scale(tonic, ~w(A Bb B C Db D Eb E F Gb G Ab))
  end

  @doc """
  Certain scales will require the use of the flat version, depending on the
  `tonic` (key) that begins them, which is C in the above examples.

  For any of the following tonics, use the flat chromatic scale:

  F Bb Eb Ab Db Gb d g c f bb eb

  For all others, use the regular chromatic scale.
  """
  @spec find_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def find_chromatic_scale(tonic) do
    case tonic do
      tonic when tonic in ["F", "Bb", "Eb", "Ab", "Db", "Gb", "d", "g", "c", "f", "bb", "eb"] ->
        chromatic_scale(tonic, ~w(Ab A Bb B C Db D Eb E F Gb G))

      _ ->
        chromatic_scale(tonic)
    end
  end

  @doc """
  The `pattern` string will let you know how many steps to make for the next
  note in the scale.

  For example, a C Major scale will receive the pattern "MMmMMMm", which
  indicates you will start with C, make a full step over C# to D, another over
  D# to E, then a semitone, stepping from E to F (again, E has no sharp). You
  can follow the rest of the pattern to get:

  C D E F G A B C
  """
  @spec scale(tonic :: String.t(), pattern :: String.t()) :: list(String.t())

  def scale(tonic, pattern) do
    upcase_tonic = tonic |> upcase()

    tonics_list =
      case upcase_tonic do
        upcase_tonic when upcase_tonic in ["Ab", "Bb", "Db", "Eb", "Gb"] ->
          ~w(Ab A Bb B C Db D Eb E F Gb G)

        # this sounds hacky, not sure how to find if scale should be flat or not
        upcase_tonic when tonic in ["d", "g"] ->
          ~w(Ab A Bb B C Db D Eb E F Gb G)

        _ ->
          ~w(A A# B C C# D D# E F F# G G#)
      end

    [upcase_tonic] ++ find_scale(upcase_tonic, pattern |> String.codepoints(), tonics_list)
  end

  defp find_scale(tonic, pattern, template, scale \\ [])
  defp find_scale(tonic, [], template, scale), do: scale

  defp find_scale(tonic, [step | t], template, scale) do
    next_tonic = step(template, tonic, step)
    find_scale(next_tonic, t, template, scale ++ [next_tonic])
  end

  defp upcase(tonic) do
    case tonic |> String.reverse() do
      "#" <> x -> String.upcase(x) <> "#"
      "b" <> x -> String.upcase(x) <> "b"
      _ -> String.upcase(tonic)
    end
  end
end
