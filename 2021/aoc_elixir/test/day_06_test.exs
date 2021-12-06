defmodule Day06Test do
  use ExUnit.Case

  test "example" do
    assert 5934 ==
             File.read!("input/6.example.txt")
             |> parse_input()
             |> simulate(80)
  end

  test "day 06 - part 1" do
    assert 359999 ==
             File.read!("input/6.txt")
             |> parse_input()
             |> simulate(80)
  end

  test "example 2" do
    assert 26984457539 ==
             File.read!("input/6.example.txt")
             |> parse_input()
             |> simulate(256)
  end

  test "day 06 - part 2" do
    assert 18864 ==
             File.read!("input/6.txt")
             |> parse_input()
             |> simulate(256)
  end

  @doc """
  returns:
  %{ 1 => 23, 2 => 12}
  Where key is the remaining time, and value is the number of fish for that time.
  """
  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  def simulate(state, 0) do
    state
    |> Map.values()
    |> Enum.sum()
  end

  def simulate(state, iterations) do
    new_state = %{
      0 => Map.get(state, 1, 0),
      1 => Map.get(state, 2, 0),
      2 => Map.get(state, 3, 0),
      3 => Map.get(state, 4, 0),
      4 => Map.get(state, 5, 0),
      5 => Map.get(state, 6, 0),
      6 => Map.get(state, 7, 0) + Map.get(state, 0, 0),
      7 => Map.get(state, 8, 0),
      8 => Map.get(state, 0, 0),
    }
    simulate(new_state, iterations - 1)
  end
end
