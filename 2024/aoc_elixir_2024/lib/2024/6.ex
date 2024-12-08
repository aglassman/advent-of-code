import AOC

aoc 2024, 6 do
  @moduledoc """
  https://adventofcode.com/2024/day/6
  """

  def guard_pos(map), do: Enum.find(map, &match?({_, "^"}, &1))

  def next_pos({x, y}, {dx, dy}), do: {x + dx, y + dy}

  def turn_right({0, -1}), do: {1, 0}
  def turn_right({1, 0}), do: {0, 1}
  def turn_right({0, 1}), do: {-1, 0}
  def turn_right({-1, 0}), do: {0, -1}

  def path(map, pos, dir, visited) do
    IO.inspect([pos, dir])
    next = next_pos(pos, dir)
    case map[next] do
      nil ->
        visited

      "#" ->
        path(map, pos, turn_right(dir), visited)

      "." ->
        path(map, next, dir, [pos | visited])
    end
  end

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    {map, width, height} = AocUtils.grid(input) |> IO.inspect()
    {pos, _} =  guard_pos(map) |> IO.inspect()
    map = Map.put(map, pos, ".")

    path(map, pos, {0, -1}, [{0, 1}])
    |> Enum.uniq()
    |> Enum.count()

  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
  end
end
