defmodule Day15Test do
  use ExUnit.Case

  test "example" do
    assert 0 ==
             File.read!("input/15.example.txt")
             |> parse_input()
             |> shortest_path()
  end

  test "day 15 - part 1" do
    assert 0 ==
             File.read!("input/15.txt")
             |> parse_input()
  end

  test "example 2" do
    assert 0 ==
             File.read!("input/15.example.txt")
             |> parse_input()
  end

  test "day 15 - part 2" do
    assert 0 ==
             File.read!("input/15.txt")
             |> parse_input()
  end

  @doc """
  returns a map of all locations in an N x N square
  Top row is {0, 0}, {1, 0} ...
  Bottom row is {N, 0}, {N, 1}, ..., {N, N}
  %{
    {x, y} => risk_level
  }
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {risk_level, x} -> {{x, y}, %{risk_level: risk_level}} end)
    end)
    |> Map.new()
  end

  @root {0, 0}

  def shortest_path(risk_map, target) do
    unvisited = risk_map

    risk_map
    |> Enum.map(fn
      {@root, _} -> {@root, %{risk_level: 0, distance: 0}}
      {position, risk} -> {position, %{risk, distance: :infinity}}
    end)
    |> Map.new()

    visited = Map.take(unvisited, @root)
    unvisited = Map.drop(unvisited, @root)

    max_x =
      risk_map
      |> Enum.map(fn {{x, _}, _} -> x end)
      |> Enum.max()

    max_y =
      risk_map
      |> Enum.map(fn {{_, y}, _} -> y end)
      |> Enum.max()

    do_shortest_path(visited, unvisited, {max_x, max_y})
  end

  def do_shortest_path(visited, to_visit, to_find) do
    Enum.min_by()
  end

  def adjacent({x, y}, risk_map) do
    current = Map.get(risk_map, {x, y})

    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.map(fn position ->
      case Map.get(risk_map, position) do
        nil -> nil
        adj -> position
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
