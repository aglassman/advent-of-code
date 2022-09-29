defmodule Day18Test do
  use ExUnit.Case

  test "example 1" do
    assert [[[[0,9],2],3],4] == reduce([[[[[9,8],1],2],3],4])
  end

  test "example 2" do
    assert [7,[6,[5,[7,0]]]] == reduce([7,[6,[5,[4,[3,2]]]]])
  end

  test "example 3" do
    assert [[6,[5,[7,0]]],3] == reduce([[6,[5,[4,[3,2]]]],1])
  end

  test "example 4" do
    assert [[[[0,9],2],3],4] == reduce([[[[[9,8],1],2],3],4])
  end

  test "example 5" do
    assert [[[[0,9],2],3],4] == reduce([[[[[9,8],1],2],3],4])
  end

  test "day 18 - part 1" do
    assert 0 ==
             File.read!("input/18.txt")
             |> parse_input()
  end

  test "example x" do
    assert 0 ==
             File.read!("input/18.txt")
             |> parse_input()
  end

  test "day 18 - part 2" do
    assert 0 ==
             File.read!("input/18.txt")
             |> parse_input()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn code ->
      {exp, _} = Code.eval_string(code)
      exp
    end)
 end

 def reduce(x, _) when is_integer(x), do: x

 def reduce([x, y], 4) do
    IO.inspect([x, y], charlists: :as_lists, label: :explode)
    {:explode, [x, y]}
 end

 def reduce([left, right] = sf_number, level \\ 0) do
    r_left = reduce(left, level + 1)
    r_right = reduce(right, level + 1)

    IO.inspect(level, charlists: :as_lists, label: :level)
    IO.inspect(left, charlists: :as_lists, label: :left)
    IO.inspect(r_left, charlists: :as_lists, label: :r_left)
    IO.inspect(right, charlists: :as_lists, label: :right)
    IO.inspect(r_right, charlists: :as_lists, label: :r_right)

    r_left = case r_left do
      {:explode, _} ->
        0
    end

    r_right = case {right, r_left} do
      { [lx, ly], {:explode, [x, y]}} ->
        [lx + y, ly]
      { li, {:explode, [x, y]}} ->
        li + y
      _ ->
        r_right
    end

    IO.inspect([r_left, r_right], charlists: :as_lists, label: :result)
    IO.puts("\n")

    [r_left, r_right]
 end

end
