defmodule Day18Test do
  use ExUnit.Case


  @example """

  """

  test "example - part 1" do
    assert 26 == eval("2 * 3 + (4 * 5)")
    assert 51 == eval("1 + (2 * 3) + (4 * (5 + 6))")
    assert 437 == eval("5 + (8 * 3 + 9 + 3 * 4 * 3)")
    assert 12240 == eval("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
    assert 13632 == eval("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
  end

  test "example - part 2" do
    assert 51 == eval("1 + (2 * 3) + (4 * (5 + 6)")
    assert 46 == eval("2 * 3 + (4 * 5)")
    assert 1445 == eval("5 + (8 * 3 + 9 + 3 * 4 * 3)")
    assert 669060 == eval("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")
    assert 23340 == eval("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
  end


  test "day 18 - part 1" do
    assert 29839238838303 == "input/18.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map_join("+", &"(#{&1})")
    |> eval()
  end

  test "day 18 - part 2" do
    assert 29839238838303 == "input/18.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map_join("+", &"(#{&1})")
    |> eval()
  end


  def eval(input) when is_binary(input) do
    input
    |> String.graphemes()
    |> Enum.reject(&(&1 == " "))
    |> Enum.map(&parse/1)
    |> eval([])
  end

  def eval([], [output]), do: output

  def eval(input, [a, "*", b] = c) when is_integer(a) and is_integer(b) do
    eval(input, [a * b])
  end

  def eval(input, [a, "+", b] = c) when is_integer(a) and is_integer(b) do
    eval(input, [a + b])
  end

  def eval(["(" | b], output) do
#    IO.inspect([:b,b, output])
    {result, remainder} = reduce(b)
    eval(remainder, [result] ++ output)
  end

  def eval([a | b], output) do
#    IO.inspect([:c, a, b, output])
    eval(b, [a] ++ output)
  end

  def reduce(input, acc \\ [], depth \\ 1)

  def reduce([], acc, depth) do
    {eval(acc, []), []}
  end

  def reduce([")" | b], acc, 1) do
    {eval(acc, []), b}
  end

  def reduce([")" | b], acc, depth) do
    reduce(b, acc ++ [")"], depth - 1)
  end

  def reduce(["(" | b], acc, depth) do
    reduce(b, acc ++ ["("], depth + 1)
  end

  def reduce([a | b], acc, depth) do
    reduce(b, acc ++ [a], depth)
  end

  def parse(x) when x in ["(", ")"], do: x
  def parse("*"), do: "*"
  def parse("+"), do: "+"
  def parse(x), do: String.to_integer(x)


end