defmodule LinkedList do
  @opaque t :: tuple()

  @typep ll_node :: %{data: any, ll_node: ll_node | nil}

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    %{data: nil, ll_node: nil}
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem) do
    %{data: elem, ll_node: list}
  end

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(list), do: _length(list)
  defp _length(list, cnt \\ 0)
  defp _length(nil, cnt), do: cnt

  defp _length(list, cnt) do
    case {list.data, list.ll_node} do
      {nil, nil} -> cnt
      _ -> _length(list.ll_node, cnt + 1)
    end
  end

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(list) do
    LinkedList.length(list) == 0
  end

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(list) do
    case {list.data, list.ll_node} do
      {nil, nil} -> {:error, :empty_list}
      _ -> {:ok, list.data}
    end
  end

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(list) do
    case {list.data, list.ll_node} do
      {nil, nil} -> {:error, :empty_list}
      _ -> {:ok, list.ll_node}
    end
  end

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(list) do
    case {list.data, list.ll_node} do
      {nil, nil} -> {:error, :empty_list}
      _ -> {:ok, list.data, list.ll_node}
    end
  end

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: _from_list(list |> Enum.reverse())
  defp _from_list(list, ll \\ %{data: nil, ll_node: nil})
  defp _from_list([], ll), do: ll
  defp _from_list([h | t], ll), do: _from_list(t, push(ll, h))

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list), do: _to_list(list)

  def _to_list(ll, list \\ []) do
    case {ll.data, ll.ll_node} do
      {nil, nil} -> list ++ []
      {data, nil} -> list ++ [data]
      {data, ll_node} -> _to_list(ll_node, list ++ [data])
    end
  end

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: _reverse(list)

  defp _reverse(list, rlist \\ %{data: nil, ll_node: nil}) do
    case {list.data, list.ll_node} do
      {nil, nil} -> rlist
      {data, nil} when data != nil -> push(rlist, data)
      {data, ll_node} -> _reverse(ll_node, push(rlist, data))
    end
  end
end
