defmodule Day19Test do
  use ExUnit.Case

  import :math, only: [cos: 1, sin: 1]

  test "rotx" do
    assert 1 == rot_x([[1, 1, 1, 1]], 90)
  end

  test "example" do
    assert 0 ==
             File.read!("input/19.example.txt")
             |> parse_input()
  end

  test "day 19 - part 1" do
    assert 0 ==
             File.read!("input/19.txt")
             |> parse_input()
  end

  test "example 2" do
     assert 0 ==
             File.read!("input/19.example.txt")
             |> parse_input()
  end

  test "day 19 - part 2" do

    assert 0 ==
             File.read!("input/19.txt")
             |> parse_input()
  end

  @doc """

  """
  def parse_input(input) do
    Regex.split(~r/--- scanner ([\d]+) ---/, input, trim: true)
    |> Enum.with_index()
    |> Enum.map(&to_scanner/1)
  end

  def to_scanner({beacon_positions_str, id}) do
    beacon_positions = beacon_positions_str
    |> String.split("\n", trim: true)
    |> Enum.map(fn beacon_position_str ->
      beacon_position_str
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)

    %{id: id, beacon_positions: beacon_positions, rotation: {0, 0, 0}}
  end

  def rot_x(point, r) do
     rx = [[1, 0 ,0, 0],
      [0, cos(r), -sin(r), 0],
      [0, sin(r), cos(r), 0 ],
      [0, 0, 0, 1]]

     Matrix.mult(point, rx)
  end

end
