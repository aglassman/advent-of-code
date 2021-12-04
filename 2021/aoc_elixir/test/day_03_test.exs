defmodule Day03Test do
  use ExUnit.Case
  use Bitwise

  @example_max "11111" |> String.to_integer(2)
  @max "111111111111" |> String.to_integer(2)

  @example_power 5
  @power 12

  test "example" do
    assert 198 ==
             File.read!("input/3.example.txt")
             |> parse_input()
             |> gamma_rate()
             |> solve_pt_1(@example_max)
  end

  test "day 03 - part 1" do
    assert 3_549_854 ==
             File.read!("input/3.txt")
             |> parse_input()
             |> gamma_rate()
             |> solve_pt_1(@max)
  end

  test "example 2" do
  end

  test "day 03 - part 2" do
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def gamma_rate(input) do
    input
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(
      &Enum.reduce(&1, 0, fn
        "0", acc -> acc - 1
        "1", acc -> acc + 1
      end)
    )
    |> Enum.map(fn
      x when x > 0 -> "1"
      _ -> "0"
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def solve_pt_1(gamma_rate, max) do
    gamma_rate * bxor(max, gamma_rate)
  end
end
