import AOC

aoc 2025, 1 do
  def p1(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn x, {pos, count} ->
      (pos + x)
      |> rem(100)
      |> case do
        v when v < 0 -> 100 + v
        v -> v
      end
      |> case do
        0 -> {0, count + 1}
        p -> {p, count}
      end
    end)
  end

  def p2(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn x, {pos, count} ->
      passed_count =
        case rem(x, 100) do
          x when pos + x > 100 -> 1
          x when pos + x < 0 and pos > 0 -> 1
          _ -> 0
        end

      passed_count = passed_count + trunc(abs(x / 100))

      (pos + x)
      |> rem(100)
      |> case do
        v when v < 0 -> 100 + v
        v -> v
      end
      |> case do
        0 -> {0, count + 1 + passed_count}
        p -> {p, count + passed_count}
      end
    end)
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Stream.map(fn
      "L" <> number -> -String.to_integer(number)
      "R" <> number -> String.to_integer(number)
    end)
  end
end
