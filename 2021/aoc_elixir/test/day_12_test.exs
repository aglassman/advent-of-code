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
    assert 36 ==
             File.read!("input/12.example.txt")
             |> parse_input()
             |> find_all_paths(:part_2)
             |> List.flatten()
             |> Enum.filter(&(&1 == "end"))
             |> Enum.count()
  end

  test "day 12 - part 2" do
    assert 131254 ==
             File.read!("input/12.txt")
             |> parse_input()
             |> find_all_paths(:part_2)
             |> List.flatten()
             |> Enum.filter(&(&1 == "end"))
             |> Enum.count()
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

  def find_all_paths(caves, part \\ :part_1) do
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

    do_find_all_paths(["start"], cave_map, part)
  end

  def do_find_all_paths(["end" | _] = path, cave_map, _), do: path

  def do_find_all_paths([current | _] = path, cave_map, part) do
    next_caves = Map.get(cave_map, current)

    next_possible_caves =
      next_caves
      |> Enum.reject(fn cave -> cave == "start" end)
      |> Enum.reject(fn cave ->
        reject_option(part, cave, path)
      end)
      |> Enum.map(fn next_cave ->
        do_find_all_paths([next_cave] ++ path, cave_map, part)
      end)
  end

  def reject_option(:part_1, cave, path) do
    Enum.any?(path, &(&1 == cave)) && !is_big?(cave)
  end

  def reject_option(:part_2, cave, path) do
    if is_big?(cave) do
      false
    else
      frequencies = Enum.frequencies(path)

      double_visit_count = frequencies
                           |> Enum.reject(fn {k, v} -> is_big?(k) || (k in ["start", "end"]) end)
                           |> Enum.filter(fn {k, v} -> v > 1 end)
                           |> Enum.count()

      double_visit_count == 1 && (Map.get(frequencies, cave, 0) > 0)
    end
  end

end
