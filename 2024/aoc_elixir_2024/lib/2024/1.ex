import AOC

aoc 2024, 1 do
  @moduledoc """
  https://adventofcode.com/2024/day/1
  """

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    input
    |> String.split("\n")
    |> Stream.map(fn line ->
      line
      |> String.split("   ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&Enum.sort/1)
    |> Stream.zip()
    |> Enum.reduce(0, fn {a, b}, sum -> sum + abs(b - a) end)
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    [list_a, list_b] = input
    |> String.split("\n")
    |> Stream.map(fn line ->
      line
      |> String.split("   ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.zip()
    |> Enum.map(&Tuple.to_list/1)

    list_b_freq = Enum.frequencies(list_b)

    Enum.reduce(list_a, 0, fn item_a, sum ->
      sum + (item_a * (list_b_freq[item_a] || 0))
    end)
  end
end
