defmodule Day11Test do
  use ExUnit.Case

  test "example - part 1" do
    assert 37 = part_1(File.read!("input/11-example.txt"))
  end

  test "day 11 - part 1" do
    assert 2247 = part_1(File.read!("input/11.txt"))
  end

  test "example - part 2" do
    assert 26 = part_2(File.read!("input/11-example.txt"))
  end

  test "day 11 - part 2" do
    assert 2011 = part_2(File.read!("input/11.txt"))
  end

  def part_1(input) do
    input
    |> to_map()
    |> find_stable({&adjacent_neighbors/2, 4})
    |> count("#")
  end

  def part_2(input) do
    input
    |> to_map()
    |> find_stable({&nearest_neighbors/2, 5})
    |> count("#")
  end

  @doc """
  Count all spaces that contain the target.
  """
  def count(map, target) do
    map
    |> Map.values()
    |> Enum.filter(&(&1 == target))
    |> Enum.count()
  end

  @doc """
  Transform the input into a map of coordinates and seat values.
  """
  def to_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, x} ->
      row
      |> String.graphemes()
      |> Stream.with_index()
      |> Stream.map(fn {seat, y} -> {{x, y}, seat} end)
    end)
    |> Enum.into(%{})
  end

  @doc """
  Given a seat's {x, y} coordinates, calculate the coordinates of the 8 adjacent spaces.
  """
  def adjacent_neighbors(_, {x, y}) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
  end

  @doc """
  Given a seat, calculate the 8 nearest coordinates that contain an open or taken seat.
  """
  def nearest_neighbors(map, seat) do
    [
      nearest_neighbor(map, seat, -1, -1),
      nearest_neighbor(map, seat, -1, 0),
      nearest_neighbor(map, seat, -1, 1),
      nearest_neighbor(map, seat, 0, -1),
      nearest_neighbor(map, seat, 0, 1),
      nearest_neighbor(map, seat, 1, -1),
      nearest_neighbor(map, seat, 1, 0),
      nearest_neighbor(map, seat, 1, 1)
    ]
  end

  def nearest_neighbor(map, {x, y} = current_location, x_aug, y_aug) do
    case Map.get(map, next_location = {x + x_aug, y + y_aug}) do
      nil -> next_location
      "." -> nearest_neighbor(map, next_location, x_aug, y_aug)
      x when x == "#" or x == "L" -> next_location
    end
  end

  @doc """
  Returns a map containing the count of neighbor types, and the current seat's value.
  Uses the passed in neighbor_calculation function to determine which neighbors to check.
  %{
    "seat" => "L",
    "#" => 3,
    "L" => 0,
    "." => 5
  }
  """
  def neighbors(neighbor_calculation, map, {x, y} = seat) do
    acc = %{"#" => 0, "L" => 0, "." => 0}

    neighbor_calculation.(map, seat)
    |> Enum.map(&Map.get(map, &1))
    |> Enum.reduce(acc, &Map.update(&2, &1, 1, fn a -> a + 1 end))
    |> Map.put("seat", Map.get(map, seat))
  end

  @doc """
  Perform one iteration of the map lifecycle using the given
  neighbor calculation, and limit where an an occupied seat will
  become unoccupied if overcrowded.
  """
  def iterate(map, {neighbor_calculation, limit}) do
    map
    |> Enum.map(fn {seat, value} ->
      case neighbors(neighbor_calculation, map, seat) do
        %{"seat" => "L", "#" => 0} -> {seat, "#"}
        %{"seat" => "#", "#" => occupied} when occupied >= limit -> {seat, "L"}
        _ -> {seat, value}
      end
    end)
    |> Enum.into(%{})
  end

  @doc """
  Recursively iterates the map until the next iteration of the map
  is the same as the input map.
  """
  def find_stable(map, neighbors) do
    next_iteration = iterate(map, neighbors)
    if map == next_iteration do
      map
    else
      find_stable(next_iteration, neighbors)
    end
  end
end
