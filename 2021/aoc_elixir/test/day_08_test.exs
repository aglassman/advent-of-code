defmodule Day07Test do
  use ExUnit.Case

  test "example" do
    assert 26 ==
             File.read!("input/8.example.txt")
             |> parse_input()
             |> part_1()
  end

  test "day 08 - part 1" do
    assert 449 ==
             File.read!("input/8.txt")
             |> parse_input()
             |> part_1()
  end

  test "example 2" do
    assert 61229 ==
             File.read!("input/8.example.txt")
             |> parse_input()
             |> part_2()
  end

  test "day 08 - part 2" do
    assert 0 ==
             File.read!("input/8.txt")
             |> parse_input()
             |> part_2()
  end

  @segment_data %{
    0 => %{count: 6, segments: MapSet.new(~w(a b c e f g))},
    1 => %{count: 2, segments: MapSet.new(~w(c f))},
    2 => %{count: 5, segments: MapSet.new(~w(a c d e g))},
    3 => %{count: 5, segments: MapSet.new(~w(a c d f g))},
    4 => %{count: 4, segments: MapSet.new(~w(b c d f))},
    5 => %{count: 5, segments: MapSet.new(~w(a b d f g))},
    6 => %{count: 6, segments: MapSet.new(~w(a b d e f g))},
    7 => %{count: 3, segments: MapSet.new(~w(a c f))},
    8 => %{count: 7, segments: MapSet.new(~w(a b c d e f g))},
    9 => %{count: 6, segments: MapSet.new(~w(a b c d f g))}
  }

  @doc """
  returns a tuple of MapSets for the signal_patterns, and output_values
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input) do
    [signal_patterns, output_values] = String.split(input, "|", trim: true)
    {to_map_set(signal_patterns), to_map_set(output_values)}
  end

  def to_map_set(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
  end

  def part_1([], acc), do: acc

  def part_1([{signal_patterns, output_values} | patterns], acc \\ 0) do
    sum =
      output_values
      |> Enum.map(&MapSet.size/1)
      |> Enum.filter(&Kernel.in(&1, [2, 4, 3, 7]))
      |> Enum.frequencies()
      |> IO.inspect()
      |> Map.values()
      |> Enum.sum()

    part_1(patterns, sum + acc)
  end

  def part_2([], acc), do: acc

  def part_2([{signal_patterns, output_values} | patterns], acc \\ 0) do
    solution = solve(MapSet.new(signal_patterns), output_values)
    part_2(patterns, solution + acc)
  end

  def solve([], output_values) do
    output_values |> IO.inspect()
  end

  def solve(signal_patterns, output_values) do
    output_values =
      output_values
      |> Enum.map(fn
        {solution, mapset} = solved ->
          solved

        output_value ->
          size = MapSet.size(output_value)

          cond do
            size == 2 -> {1, output_value}
            size == 4 -> {4, output_value}
            size == 3 -> {7, output_value}
            size == 7 -> {8, output_value}
            size == 5 ->
            size == 6 ->
          end
      end)

    remaining_signal_patterns =
      Enum.reduce(
        output_values,
        signal_patterns,
        fn
          {solution, mapset}, acc ->
            MapSet.delete(acc, mapset)

          output_value, acc ->
            acc
        end
      )

      solve(remaining_signal_patterns, output_values)
  end
end
