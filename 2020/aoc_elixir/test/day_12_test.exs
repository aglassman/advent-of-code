defmodule Day12Test do
  use ExUnit.Case

  @example """
  F10
  N3
  F7
  R90
  F11
  """

  test "example - part 1" do
    assert 25 == part_1(@example)
  end

  test "day 12 - part 1" do
    assert 636 == part_1(File.read!("input/12.txt"))
  end

  test "example - part 2" do
    assert 286 == part_2(@example)
  end

  test "day 12 - part 2" do
    assert 26841 == part_2(File.read!("input/12.txt"))
  end

  def part_1(input) do
    {_, x, y} = input
    |> to_nav_instructions()
    |> navigate({"E", 0, 0})
    abs(x) + abs(y)
  end

  def part_2(input) do
    {{x, y}, _, _} = input
    |> to_nav_instructions()
    |> navigate({{0, 0}, 10, 1})
    abs(x) + abs(y)
  end

  def to_nav_instructions(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn <<action::binary-size(1)>> <> value -> {action, String.to_integer(value)} end)
  end

  def navigate([], current_position) do
    current_position
  end

  def navigate([instruction | instructions], current_position) do
    navigate(instructions, next_position(current_position, instruction |> IO.inspect()) |> IO.inspect())
  end

  # shared
  def next_position({x, lat, long}, {"N", val}), do: {x, lat, long + val}
  def next_position({x, lat, long}, {"S", val}), do: {x, lat, long - val}
  def next_position({x, lat, long}, {"E", val}), do: {x, lat + val, long}
  def next_position({x, lat, long}, {"W", val}), do: {x, lat - val, long}


  # part 2 calc (waypoint)
  def next_position({{_,_},_,_} = pos_wp, {rot, deg}) when rot in ["L", "R"] and deg == 0 , do: pos_wp
  def next_position({{_,_} = pos, x, y}, {"L", deg}), do: next_position({pos, -y, x}, {"L", deg - 90})
  def next_position({{_,_} = pos, x, y}, {"R", deg}), do: next_position({pos, y, -x}, {"R", deg - 90})

  def next_position({{_,_},_,_} = pos_wp, {"F", 0}), do: pos_wp
  def next_position({{p_x, p_y}, wp_x, wp_y}, {"F", val}), do:
    next_position({{p_x + wp_x, p_y + wp_y}, wp_x, wp_y}, {"F", val - 1})

  # part 1 calc
  def next_position({facing, lat, long}, {"L", deg}), do: {rot(facing, "L", deg), lat, long }
  def next_position({facing, lat, long}, {"R", deg}), do: {rot(facing, "R", deg), lat, long}
  def next_position({facing, _, _} = pos, {"F", val}), do: next_position(pos, {facing, val})


  def rot(facing, rot, deg) when rot in ["L", "R"] and deg == 0, do: facing
  def rot("N", "L", deg), do: rot("W", "L", deg - 90)
  def rot("W", "L", deg), do: rot("S", "L", deg - 90)
  def rot("S", "L", deg), do: rot("E", "L", deg - 90)
  def rot("E", "L", deg), do: rot("N", "L", deg - 90)

  def rot("N", "R", deg), do: rot("E", "R", deg - 90)
  def rot("E", "R", deg), do: rot("S", "R", deg - 90)
  def rot("S", "R", deg), do: rot("W", "R", deg - 90)
  def rot("W", "R", deg), do: rot("N", "R", deg - 90)


end