import AOC

aoc 2022, 21 do
  def p1(input) do
    input
    |> parse()
    |> yell("root")
  end

  def p2(input) do

  end

  def yell(monkies, target) do
    case monkies[target] do
      %{val: x} ->
          x
      %{a: a, op: op, b: b} ->
        op.(yell(monkies, a), yell(monkies, b))
    end
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      [key, eq] = String.split(line, ": ")
      Map.put(acc, key, parse_eq(eq))
    end)
  end

  def parse_eq(input) do
    case String.split(input, " ") do
      [a, op, b] ->
        op = case op do
          "+" -> &+/2
          "-" -> &-/2
          "/" -> &(trunc(&1 / &2))
          "*" -> &*/2
        end
        %{a: a, op: op, b: b}
      [val] ->
        %{val: String.to_integer(val)}
    end
  end
end
