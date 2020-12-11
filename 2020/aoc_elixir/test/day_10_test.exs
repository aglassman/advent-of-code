defmodule Day10Test do
  use ExUnit.Case

  test "example - part 1" do
    assert 35 = part_1(File.read!("input/10-example.txt"))
  end

  test "day 10 - part 1" do
    assert 2112 = part_1(File.read!("input/10.txt"))
  end

  test "example - part 2" do
    assert 8 == part_2(File.read!("input/10-example.txt"))
    assert 19208 == part_2(File.read!("input/10-example-2.txt"))
  end

  test "day 10 - part 2" do
    assert 3_022_415_986_688 == part_2(File.read!("input/10.txt"))
  end

  def part_1(input) do
    %{1 => a, 3 => b} =
      input
      |> full_chain()
      |> jolt_differences()
      |> jolt_difference_map()

    a * b
  end

  def part_2(input) do
    input
    |> full_chain()
    |> jolt_differences()
    |> Enum.chunk_by(&(&1 == 3))
    |> Enum.reject(&match?([3 | _], &1))
    |> Enum.map(&calc_combos(&1))
    |> Enum.reduce(&*/2)
  end

  def calc_combos(combos) do
    combos
    |> Enum.with_index()
    |> Enum.reduce(1, fn {_, i}, acc -> acc + i end)
  end

  def full_chain(input) do
    chain =
      String.split(input, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()

    [last] = Enum.take(chain, -1)

    [0] ++ chain ++ [last + 3]
  end

  def jolt_differences(chain) do
    chain
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [a, b] -> b - a end)
  end

  def jolt_difference_map(jolt_differences) do
    Enum.reduce(
      jolt_differences,
      %{},
      &Map.update(&2, &1, 1, fn a -> a + 1 end)
    )
  end
end
