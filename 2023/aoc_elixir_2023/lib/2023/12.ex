import AOC

aoc 2023, 12 do
  @moduledoc """
  https://adventofcode.com/2023/day/12
  """

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [pattern, record] ->
      spring = String.graphemes(pattern)
      record = record |> String.split(",") |> Enum.map(&String.to_integer/1)
      {
        length(spring),
        String.graphemes(pattern),
        Enum.sum(record),
        record
      }
    end)
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    parse(input)
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
  end
end
