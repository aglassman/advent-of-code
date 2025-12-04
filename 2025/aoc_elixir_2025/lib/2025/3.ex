import AOC

aoc 2025, 3 do
  def p1(input) do
    banks = parse(input)

    banks
    |> Enum.map(&max_joltage/1)
    |> Enum.sum()
    |> dbg()
  end

  def max_joltage(bank, on \\ [])

  def max_joltage([], [a, b]), do: a + b

  def max_joltage([a | bank], []), do: max_joltage(bank, [a])

  def max_joltage([a | bank], [b, c]) when a + c > b + c, do: max_joltage(bank, [b, a])

  def max_joltage([a | bank], [b, c]) when a + c <= b + c, do: max_joltage(bank, [b, c])

  def max_joltage([a | bank], [b]), do: max_joltage(bank, [a, b])

  def p2(input) do
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn bank ->
      bank
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
