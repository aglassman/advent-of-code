defmodule Day05Test do
  use ExUnit.Case
  use Bitwise

  test "example" do
    assert 5 ==
             File.read!("input/5.example.txt")
             |> parse_input()
             |> chart()
             |> solve()
  end

  test "day 05 - part 1" do
    assert 6283 ==
             File.read!("input/5.txt")
             |> parse_input()
             |> chart()
             |> solve()
  end

  test "example 2" do
    assert 12 ==
             File.read!("input/5.example.txt")
             |> parse_input()
             |> chart(true)
             |> solve()
  end

  test "day 05 - part 2" do
    assert 18864 ==
             File.read!("input/5.txt")
             |> parse_input()
             |> chart(true)
             |> solve()
  end

  @doc """
  returns:
  [{{x1, y1}, {x2, y2}}, ...]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/([\d]+),([\d]+) -> ([\d]+),([\d]+)/, &1))
    |> Enum.map(fn [_, x1, y1, x2, y2] -> {{i(x1), i(y1)}, {i(x2), i(y2)}} end)
  end

  def i(string), do: String.to_integer(string)

  @doc """
  Take the lines as inputs, and put them into a chart of coordinates.
  If no line exists in a particular coordinate, then there will be no
  entry.
  """
  def chart(lines, consider_diagonal \\ false, chart \\ %{}) do
    Enum.reduce(lines, chart, fn {{x1, y1}, {x2, y2}} = line, chart ->
      cond do
        x1 == x2 || y1 == y2 ->
          for x <- x1..x2, y <- y1..y2, do: {{x, y}, 1}
        consider_diagonal ->
          len = abs(x1 - x2)
          x_dir = (x2 - x1) / len |> trunc
          y_dir = (y2 - y1) / len |> trunc
          for i <- 0..len do
            {{x1 + (i * x_dir), y1 + (i * y_dir)}, 1}
          end
        true ->
          []
      end
      |> Map.new()
      |> Map.merge(chart, fn _, a, b -> a + b end)
    end)
  end

  def solve(chart) do
    chart
    |> Enum.reject(fn {k, v} -> v < 2 end)
    |> Enum.count()
  end
end
