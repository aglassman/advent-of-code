defmodule Day09Test do
  use ExUnit.Case

  test "example" do
    assert 15 ==
             File.read!("input/9.example.txt")
             |> parse_input()
             |> low_points()
             |> solve()
  end

  test "day 09 - part 1" do
    assert 594 ==
             File.read!("input/9.txt")
             |> parse_input()
             |> low_points()
             |> solve()
  end

  test "example 2" do
    assert 1134 ==
             File.read!("input/9.example.txt")
             |> parse_input()
             |> low_points()
             |> basins()
             |> solve()
  end

  test "day 09 - part 2" do
    assert 0 ==
             File.read!("input/9.txt")
             |> parse_input()
             |> low_points()
             |> basins()
             |> solve()
  end

  @doc """
  returns a map of all locations in an N x N square
  Top row is {0, 0}, {1, 0} ...
  Bottom row is {N, 0}, {N, 1}, ..., {N, N}
  %{
    {x, y} => height
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
      |> Enum.map(fn {height, x} -> {{x, y}, height} end)
    end)
    |> Map.new()
  end

  def low_points(height_map) do
    low_points = height_map
    |> Enum.filter(fn {position, height} ->
      any_adj_higher = position
      |> adjacent(height_map)
      |> Enum.any?(fn {_position, adj_height} -> adj_height <= height end)

      !any_adj_higher
    end)

    {:low_points, height_map, low_points}
  end

  def basins({:low_points, height_map, low_points}) do
    basins = Enum.map(low_points, fn low_point ->
      [low_point]
      |> basin(height_map)
      |> Enum.uniq()
    end)

    {:basins, height_map, basins}
  end

  def basin([], _height_map, basin), do: basin

  def basin([{lp_position, lp_height} = low_point | low_points], height_map, basin \\ []) do
    expansion = lp_position
    |> adjacent(height_map)
    |> Enum.reject(fn {position, height} -> height <= lp_height || height == 9 end)

    basin(low_points ++ expansion, height_map, basin ++ [low_point] ++ expansion)
  end

  def adjacent({x, y}, height_map) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.map(fn position ->
      case Map.get(height_map, position) do
        nil -> nil
        height -> {position, height}
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def solve({:low_points, _height_map, low_points}) do
    low_points
    |> Enum.map(fn {_position, height} -> 1 + height end)
    |> Enum.sum()
  end

  def solve({:basins, _height_map, basins}) do
    basins
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&*/2)
  end
end
