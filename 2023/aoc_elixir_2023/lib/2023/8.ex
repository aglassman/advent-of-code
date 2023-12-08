import AOC

aoc 2023, 8 do
  @moduledoc """
  https://adventofcode.com/2023/day/8
  """

  def parse(input) do
    [pattern_input, map_input] = String.split(input, "\n\n")

    pattern = String.graphemes(pattern_input)

    map = map_input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " = "))
    |> Enum.map(fn [key, "(" <> <<a::binary-size(3)>> <> ", " <> <<b::binary-size(3)>> <> _] -> {key, %{"L" => a, "R" => b}} end)
    |> Map.new()

    {pattern, map}
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    {pattern, map} = parse(input)

    pattern
    |> Stream.cycle()
    |> Enum.reduce_while({"AAA", 0}, fn direction, {position, step} ->
      case map[position][direction] do
        "ZZZ" ->
          {:halt, step + 1}
        new_position ->
          {:cont, {new_position, step + 1}}
      end
    end)
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    {pattern, map} = parse(input)

    starts = map |> Map.keys() |> Enum.filter(fn <<_::binary-size(2)>> <> x -> x == "A" end)
    ends = map |> Map.keys() |> Enum.filter(fn <<_::binary-size(2)>> <> x -> x == "Z" end) |> MapSet.new()

    nums = for start <- starts do
      pattern
      |> Stream.cycle()
      |> Enum.reduce_while({[start], 0, 0, 0}, fn direction, {positions, step, iterations, prev} ->
        new_positions = Enum.map(positions, fn position -> map[position][direction] end)
        case new_positions == [start] || Enum.all?(new_positions, &MapSet.member?(ends, &1)) do
          true ->
            {:halt, step + 1}
          false ->
            {:cont, {new_positions, step + 1, iterations, prev}}
        end
      end)
    end

    nums |> Enum.reduce(fn a, b ->  trunc(a * b / Integer.gcd(a, b)) end)

  end
end
