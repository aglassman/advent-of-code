defmodule Day17Test do
  use ExUnit.Case

  @example """
  .#.
  ..#
  ###
  """

  @input """
  #.##.##.
  .##..#..
  ....#..#
  .##....#
  #..##...
  .###..#.
  ..#.#..#
  .....#..
  """

  test "example - part 1" do
    assert 24 = cube(@input) |> Enum.count()
    assert [{0, 7}, {0, 7}, {0, 0}] = cube(@input) |> min_max()
    assert 1 = cube(@input) |> live_neighbors([0, 0, 0])
    assert 6 = cube(@input) |> live_neighbors([2, 4, 0])
  end

  test "example" do
    assert 112 =
             @example
             |> cube()
             |> run(6)
             |> Enum.count()
  end

  test "day 17 - part 2" do
    assert 1504 =
             @input
             |> cube()
             |> run(6)
             |> Enum.count()
  end

  defguard is_alive?(cube, coord) when is_map_key(cube, coord)

  def get_symbol(cube, coord) do
    case Map.get(cube, coord) do
      nil -> "."
      _ -> "#"
    end
  end

  def run(cube, count) when count == 0, do: cube

  def run(cube, count), do: run(iterate(cube), count - 1)

  def iterate(cube) do
    cube
    |> Enum.reduce(%{}, fn {coord, _}, next_cube ->
      neighbors(coord)
      |> Enum.map(&iterate(cube, next_cube, &1))
      |> Enum.reduce(&Map.merge(&1, &2))
      |> Map.merge(next_cube)
    end)
  end

  def iterate(cube, next_cube, coord) do
    case live_neighbors(cube, coord) do
      count when is_alive?(cube, coord) and count in [2, 3] ->
        Map.put(next_cube, coord, true)

      count when not is_alive?(cube, coord) and count == 3 ->
        Map.put(next_cube, coord, true)

      _ ->
        next_cube
    end
  end

  def neighbors([x, y, z, w]) do
    for xp <- [x - 1, x, x + 1],
        yp <- [y - 1, y, y + 1],
        zp <- [z - 1, z, z + 1],
        wp <- [w - 1, w, w + 1],
        do: [xp, yp, zp, wp]
  end

  def live_neighbors(cube, coord) do
    neighbors(coord)
    |> Enum.reject(fn neighbor ->
      neighbor == coord || !Map.has_key?(cube, neighbor)
    end)
    |> Enum.count()
  end

  def cube(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, y} ->
      row
      |> String.graphemes()
      |> Stream.with_index()
      |> Stream.reject(fn {v, _} -> v == "." end)
      |> Stream.map(fn {"#", x} -> {[x, y, 0, 0], true} end)
    end)
    |> Enum.into(%{})
  end

  def min_max(cube) do
    cube
    |> Map.keys()
    |> Stream.zip()
    |> Stream.map(&dimension/1)
    |> Enum.map(&apply(Range, :new, &1))
    |> Enum.into([])
  end

  def dimension(dimension) do
    dimension
    |> Tuple.to_list()
    |> Enum.min_max()
    |> Tuple.to_list()
  end
end
