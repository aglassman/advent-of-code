import AOC

aoc 2024, 2 do
  @moduledoc """
  https://adventofcode.com/2024/day/2
  """

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def safe?(list, inc? \\ nil)
  def safe?(list, _) when length(list) <= 1, do: :safe
  def safe?([a, b | _] = list, nil) when abs(a - b) >= 1, do: safe?(list, a - b > 0)
  def safe?([a, b | _], _) when abs(a - b) < 1, do: :unsafe
  def safe?([a, b | _], true) when not (a - b in 1..3), do: :unsafe
  def safe?([a, b | _], false) when not (a - b in -1..-3//-1), do: :unsafe
  def safe?([_, b | tail], dir), do: safe?([b | tail], dir)


  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    input
    |> parse()
    |> Enum.map(&safe?/1)
    |> Enum.filter(& &1 == :safe)
    |> length()
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    %{safe: safe, unsafe: unsafe} = input
    |> parse()
    |> Enum.group_by(&safe?/1)

    dampened_safe = unsafe
    |> Enum.count(fn levels ->
      0..length(levels)
      |> Stream.map(&List.delete_at(levels, &1))
      |> Enum.any?(&(safe?(&1) == :safe))
    end)

    length(safe) + dampened_safe
  end
end
