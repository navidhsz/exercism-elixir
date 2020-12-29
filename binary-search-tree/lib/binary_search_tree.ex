defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(tree, data) do
    case {tree.data, tree.left, tree.right} do
      {d, _, nil} when data > d -> %{tree | right: new(data)}
      {d, nil, _} when data <= d -> %{tree | left: new(data)}
      {d, _, right} when data > d -> %{tree | right: insert(right, data)}
      {d, left, _} when data <= d -> %{tree | left: insert(left, data)}
    end
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree) do
    case {tree.data, tree.left, tree.right} do
      {d, nil, nil} -> [d]
      {d, left, nil} -> in_order(left) ++ [d]
      {d, nil, right} -> [d] ++ in_order(right)
      {d, left, right} -> in_order(left) ++ [d] ++ in_order(right)
    end
  end
end
