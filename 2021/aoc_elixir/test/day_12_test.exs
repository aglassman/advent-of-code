defmodule Day12Test do
  use ExUnit.Case

  test "example" do
    assert 10 ==
             File.read!("input/12.example.txt")
             |> parse_input()
             |> find_all_paths()
             |> List.flatten()
             |> Enum.filter(&(&1 == "end"))
             |> Enum.count()
  end

  test "day 12 - part 1" do
    assert 4495 ==
             File.read!("input/12.txt")
             |> parse_input()
             |> find_all_paths()
             |> List.flatten()
             |> Enum.filter(&(&1 == "end"))
             |> Enum.count()
  end

  test "example 2" do
    assert 0 ==
             File.read!("input/12.example.txt")
             |> parse_input()
  end

  test "day 12 - part 2" do
    assert 0 ==
             File.read!("input/12.txt")
             |> parse_input()
  end

  @doc """
  [{:start, {:big, A, visit_count }, {{:small, c, visit_count}, :end}, ...]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
  end

  def is_big?(cave) do
    Regex.match?(~r/[A-Z]+/, cave)
  end

  def find_all_paths(caves) do
    cave_map =
      Enum.reduce(
        caves,
        %{},
        fn [a, b], cave_map ->
          cave_map
          |> Map.update(a, [b], fn x -> x ++ [b] end)
          |> Map.update(b, [a], fn x -> x ++ [a] end)
        end
      )

    do_find_all_paths(["start"], cave_map)
  end

  def do_find_all_paths(["end" | _] = path, cave_map), do: path

  def do_find_all_paths([current | _] = path, cave_map) do
    next_caves = Map.get(cave_map, current)

    next_possible_caves =
      next_caves
      |> Enum.reject(fn cave ->
        Enum.any?(path, &(&1 == cave)) && !is_big?(cave)
      end)
      |> Enum.map(fn next_cave ->
        do_find_all_paths([next_cave] ++ path, cave_map)
      end)
  end

end
