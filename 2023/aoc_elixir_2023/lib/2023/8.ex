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

    nums = for <<_::binary-size(2)>> <> "A" = start <- Map.keys(map) do
      pattern
      |> Stream.cycle()
      |> Enum.reduce_while({start, 0}, fn direction, {position, step} ->
        case map[position][direction] do
          <<_::binary-size(2)>> <> "Z" ->
            {:halt, step + 1}
          new_position ->
            {:cont, {new_position, step + 1}}
        end
      end)
    end

    Enum.reduce(nums, fn a, b ->  trunc(a * b / Integer.gcd(a, b)) end)
  end
end
