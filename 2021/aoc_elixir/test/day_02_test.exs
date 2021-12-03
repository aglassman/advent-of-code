defmodule Day02Test do
  use ExUnit.Case

  test "example" do
    assert 150 ==
             File.read!("input/2.example.txt")
             |> parse_input()
             |> navigate()
             |> solve()
  end

  test "day 01 - part 1" do
    assert 1_840_243 ==
             File.read!("input/2.txt")
             |> parse_input()
             |> navigate()
             |> solve()
  end

  test "example 2" do
    assert 900 ==
             File.read!("input/2.example.txt")
             |> parse_input()
             |> navigate_with_aim()
             |> solve()
  end

  test "day 01 - part 2" do
    assert 1_727_785_422 ==
             File.read!("input/2.txt")
             |> parse_input()
             |> navigate_with_aim()
             |> solve()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trum: true))
    |> Enum.map(fn [direction, val] -> {direction, String.to_integer(val)} end)
  end

  def navigate(input) do
    Enum.reduce(
      input,
      {0, 0},
      fn {direction, value}, {horizontal, depth} ->
        case direction do
          "forward" ->
            {horizontal + value, depth}

          "up" ->
            {horizontal, depth - value}

          "down" ->
            {horizontal, depth + value}
        end
      end
    )
  end

  def navigate_with_aim(input) do
    Enum.reduce(
      input,
      {0, 0, 0},
      fn {direction, value}, {horizontal, depth, aim} ->
        case direction do
          "forward" ->
            {horizontal + value, depth + aim * value, aim}

          "up" ->
            {horizontal, depth, aim - value}

          "down" ->
            {horizontal, depth, aim + value}
        end
      end
    )
  end

  def solve({horizontal, depth}), do: horizontal * depth
  def solve({horizontal, depth, _}), do: horizontal * depth
end
