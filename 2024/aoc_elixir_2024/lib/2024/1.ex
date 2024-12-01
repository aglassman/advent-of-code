import AOC

aoc 2024, 1 do
  @moduledoc """
  https://adventofcode.com/2024/day/1
  """

  def parse(input) do
    input
    |> String.split("\n")
    |> Stream.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.zip()
    |> Stream.map(&Tuple.to_list/1)
  end

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    input
    |> parse()
    |> Stream.map(&Enum.sort/1)
    |> Stream.zip()
    |> Enum.reduce(0, fn {l, r}, sum -> sum + abs(l - r) end)
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    [left, right] =
      input
      |> parse()
      |> Enum.to_list()

    freq = Enum.frequencies(right)

    Enum.reduce(left, 0, fn l, sum ->
      sum + l * (freq[l] || 0)
    end)
  end
end
