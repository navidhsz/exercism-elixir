defmodule RobotSimulator do
  defstruct direction: nil, position: nil

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    is_valid_direction = direction in [:north, :south, :west, :east]

    is_valid_tuple =
      is_tuple(position) and tuple_size(position) == 2 and is_number(elem(position, 0)) and
        is_number(elem(position, 1))

    cond do
      is_valid_direction and not is_valid_tuple -> {:error, "invalid position"}
      is_valid_tuple and not is_valid_direction -> {:error, "invalid direction"}
      true -> %RobotSimulator{direction: direction, position: position}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  def simulate(robot, ""), do: robot

  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    [h | t] = instructions |> String.codepoints()
    new_instructions = t |> List.to_string()

    {x, y} = robot.position
    direction = robot.direction

    case h do
      "R" when direction == :north ->
        %{robot | direction: :east} |> simulate(new_instructions)

      "R" when direction == :east ->
        %{robot | direction: :south} |> simulate(new_instructions)

      "R" when direction == :south ->
        %{robot | direction: :west} |> simulate(new_instructions)

      "R" when direction == :west ->
        %{robot | direction: :north} |> simulate(new_instructions)

      "L" when direction == :north ->
        %{robot | direction: :west} |> simulate(new_instructions)

      "L" when direction == :west ->
        %{robot | direction: :south} |> simulate(new_instructions)

      "L" when direction == :south ->
        %{robot | direction: :east} |> simulate(new_instructions)

      "L" when direction == :east ->
        %{robot | direction: :north} |> simulate(new_instructions)

      "A" when direction == :north ->
        %{robot | position: {x, y + 1}} |> simulate(new_instructions)

      "A" when direction == :south ->
        %{robot | position: {x, y - 1}} |> simulate(new_instructions)

      "A" when direction == :west ->
        %{robot | position: {x - 1, y}} |> simulate(new_instructions)

      "A" when direction == :east ->
        %{robot | position: {x + 1, y}} |> simulate(new_instructions)

      _ ->
        {:error, "invalid instruction"}
    end
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end
end
