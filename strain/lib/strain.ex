defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    perform_action(list, fun, :keep)
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    perform_action(list, fun, :discard)
  end

  defp perform_action(res \\ [], list, _fun, _action_type) when list == [] do
    res
  end

  defp perform_action(res, [head | tail], fun, action_type) do
    (res ++
       cond do
         fun.(head) == false and action_type == :keep -> []
         fun.(head) == true and action_type == :keep -> [head]
         fun.(head) == true and action_type == :discard -> []
         fun.(head) == false and action_type == :discard -> [head]
       end)
    |> perform_action(tail, fun, action_type)
  end
end
