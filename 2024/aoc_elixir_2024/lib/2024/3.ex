import AOC

aoc 2024, 3 do
  @moduledoc """
  https://adventofcode.com/2024/day/3
  """

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    ~r/mul\(([\d]+),([\d]+)\)|don't\(\)/
    |> Regex.scan(input)
    |> Enum.map(fn [_, a, b] ->
      String.to_integer(a) * String.to_integer(b)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    ~r/mul\(([\d]+),([\d]+)\)|do\(\)|don't\(\)/
    |> Regex.scan(input)
    |> Enum.reduce({true, 0}, fn
      ["don't()"], {_, count} -> {false, count}
      ["do()"], {_, count} -> {true, count}
      [_, a, b], {true, count} ->
        {true, count + (String.to_integer(a) * String.to_integer(b))}
      _, acc -> acc
    end)
  end
end
