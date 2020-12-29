defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: reduce(l, 0, fn x, acc -> acc + 1 end)

  @spec reverse(list) :: list
  def reverse([]), do: []
  def reverse(l), do: reduce(l, [], fn x, acc -> [x | acc] end)

  @spec map(list, (any -> any)) :: list
  def map([], f), do: []
  def map([h | t], f), do: [f.(h) | map(t, f)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], f), do: []

  def filter([h | t], f) do
    case f.(h) do
      true -> [h | filter(t, f)]
      false -> filter(t, f)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, f), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append([], []), do: []
  def append([], b), do: b
  def append(a, []), do: a
  def append([h | t], b), do: [h | append(t, b)]

  @spec concat([[any]]) :: [any]
  def concat([]), do: []
  def concat([h | t]), do: append(h, concat(t))
end
