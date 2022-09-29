defmodule Day14Test do
  use ExUnit.Case

  test "example" do
    assert 1588 ==
             File.read!("input/14.example.txt")
             |> parse_input()
             |> step()
             |> solve()
  end

  test "day 14 - part 1" do
    assert 0 ==
             File.read!("input/14.txt")
             |> parse_input()
             |> step()
             |> solve()
  end

  test "example 2" do
    assert 2_188_189_693_529 ==
             File.read!("input/14.example.txt")
             |> parse_input()
             |> step(40)
             |> solve()
  end

  test "day 14 - part 2" do
    assert 0 ==
             File.read!("input/14.txt")
             |> parse_input()
  end

  @doc """

  """
  def parse_input(input) do
    [polymer_template_str, insertion_rules_str] = String.split(input, "\n\n", trim: true)
    {polymer_template(polymer_template_str), insertion_rules(insertion_rules_str)}
  end

  def polymer_template(str) do
    String.graphemes(str)
  end

  def insertion_rules(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.reduce(
      %{},
      fn rule, rule_map ->
        [input, output] = String.split(rule, " -> ", trim: true)
        Map.put(rule_map, String.graphemes(input), output)
      end
    )
  end

  def step(result, 0), do: result

  def step({template, rules}, steps \\ 10) do
    # IO.inspect(steps)
    IO.inspect(solve({template, rules}))

    new_template =
      template
      |> Enum.chunk_every(2, 1, [])
      |> Enum.map(fn
        [a, b] = rule ->
          [a, Map.get(rules, rule), b]

        [a] ->
          [a]
      end)
      |> Enum.reduce([], fn
        [a, b, c], acc ->
          acc ++ [a, b]

        [a], acc ->
          acc ++ [a]
      end)
      |> List.flatten()

    step({new_template, rules}, steps - 1)
  end

  def solve({template, rules}) do
    {{_, min}, {_, max}} =
      template
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {k, v} -> v end)

    max - min
  end
end
