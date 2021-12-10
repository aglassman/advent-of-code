defmodule Day10Test do
  use ExUnit.Case

  test "example" do
    assert 26397 ==
             File.read!("input/10.example.txt")
             |> parse_input()
             |> check_program_syntax()
             |> solve()
  end

  test "day 10 - part 1" do
    assert 0 ==
             File.read!("input/10.txt")
             |> parse_input()
             |> check_program_syntax()
             |> solve()
  end

  test "example 2" do
    assert 288957 ==
             File.read!("input/10.example.txt")
             |> parse_input()
             |> check_program_syntax()
             |> solve_pt2()
  end

  test "day 10 - part 2" do
    assert 0 ==
             File.read!("input/10.txt")
             |> parse_input()
             |> check_program_syntax()
             |> solve_pt2()
  end


  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  @doc """
  Returns list of tuples:
  {:corrupted | :incomplete | :ok, line_index, line, invalid_character | nil}
  """
  def check_program_syntax(parsed_lines) do
    parsed_lines
    |> Enum.with_index()
    |> Enum.map(&check_line_syntax/1)
  end

  def check_line_syntax({line, line_index}) do
    Enum.reduce_while(
      line ++ [:end],
      [],
      fn
        :end, _stack = [] ->
          {:halt, {:ok, line_index, line, nil}}
        :end, stack when length(stack) > 0 ->
          {:halt, {:incomplete, line_index, line, stack}}
        ")", ["(" | stack] ->
          {:cont, stack}
        "}", ["{" | stack] ->
          {:cont, stack}
        "]", ["[" | stack] ->
          {:cont, stack}
        ">", ["<" | stack] ->
          {:cont, stack}
        current_character, _stack when current_character in [")", "}", "]", ">"] ->
          {:halt, {:corrupted, line_index, line, current_character}}
        current_character, stack ->
          {:cont, [current_character] ++ stack}
      end
    )
  end

  @point_map %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
  }

  def solve(line_outputs) do
    line_outputs
    |> Enum.map(fn
      {:corrupted, _line_index, _line, illegal_character} -> Map.get(@point_map, illegal_character)
      _ -> 0
    end)
    |> Enum.sum()
  end

  @point_map_pt2 %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4,
  }

  def solve_pt2(line_outputs) do
    scores = line_outputs
    |> Enum.map(fn
      {:incomplete, _line_index, _line, stack} ->
        stack
        |> IO.inspect()
        |> Enum.reduce(0, fn character, acc ->
          (acc * 5) + Map.get(@point_map_pt2, character)
        end)
      _ -> nil
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.sort()

    Enum.at(scores, (length(scores) / 2 |> trunc))
  end

end
