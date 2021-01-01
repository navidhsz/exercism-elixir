defmodule Markdown do
  @paragraph_tag "p"
  @md_list_tag "li"
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</li></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m |> String.split("\n") |> Enum.reduce("", &"#{&2}#{process(&1)}") |> patch()
  end

  defp process(t) do
    case String.first(t) do
      "#" -> t |> parse_header_md_level() |> enclose_with_header_tag()
      "*" -> t |> parse_list_md_level()
      _ -> t |> enclose_with_paragraph_tag()
    end
  end

  defp parse_header_md_level(l) do
    [h | t] = String.split(l)
    {String.length(h), Enum.join(t, " ")}
  end

  defp parse_list_md_level(l) do
    l
    |> String.trim_leading("*")
    |> join_words_with_tags(@md_list_tag)
  end

  defp enclose_with_header_tag({hl, htl}) do
    "<h#{hl}>#{htl}</h#{hl}>"
  end

  defp enclose_with_paragraph_tag(t) do
    t |> join_words_with_tags(@paragraph_tag)
  end

  defp join_words_with_tags(t, tag) do
    "<#{tag}>#{
      t
      |> String.split()
      |> Enum.map(&replace_md_with_tag(&1))
      |> Enum.join(" ")
    }</#{tag}>"
  end

  defp replace_md_with_tag(w) do
    w |> replace_prefix_md |> replace_suffix_md
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^__/ -> String.replace(w, "__", "<strong>", global: false)
      w =~ ~r/^_/ -> String.replace(w, "_", "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/__/ -> String.replace(w, "__", "</strong>", global: false)
      w =~ ~r/_/ -> String.replace(w, "_", "</em>", global: false)
      true -> w
    end
  end

  defp patch(l) do
    l
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
