import AOC

aoc 2024, 7 do
  @moduledoc """
  https://adventofcode.com/2024/day/7
  """

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1,":"))
    |> Enum.map(fn [a, b] -> [a | String.split(b, " ", trim: true)] end)
    |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
  end

  def valid?([final, final]), do: 1
  def valid?([_, _]), do: 0
  def valid?([final, a,  b | tail]) do
    valid?([final, a + b | tail]) + valid?([final, a * b | tail]) + valid?([final, String.to_integer("#{a}#{b}") | tail]) # Part 2 only
  end

  def calc(valid_counts) do
    Enum.reduce(valid_counts, 0, fn
      {[final | _], count}, sum when count > 0 -> sum + final
      _, sum -> sum
    end)
  end

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    input
    |> parse()
    |> Enum.map(&{&1, valid?(&1)})
    |> calc()
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    input
    |> parse()
    |> Enum.map(&{&1, valid?(&1)})
    |> calc()
  end
end
