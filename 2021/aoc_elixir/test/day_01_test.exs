defmodule Day01Test do
  use ExUnit.Case

  test "example" do
    assert 7 ==
             File.read!("input/1.example.txt")
             |> parse_input()
             |> increased_count()
  end

  test "day 01 - part 1" do
    assert 1602 ==
             File.read!("input/1.txt")
             |> parse_input()
             |> increased_count()
  end

  test "example 2" do
    assert 5 ==
             File.read!("input/1.example_2.txt")
             |> parse_input()
             |> sliding_window_count()
  end

  test "day 01 - part 2" do
    assert 1633 ==
             File.read!("input/1.txt")
             |> parse_input()
             |> sliding_window_count()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def increased_count(int_list) do
    int_list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [a, b], acc ->
      if b > a do
        acc + 1
      else
        acc
      end
    end)
  end

  def sliding_window_count(int_list) do
    int_list
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [a_window, b_window], acc ->
      if Enum.sum(b_window) > Enum.sum(a_window) do
        acc + 1
      else
        acc
      end
    end)
  end
end
