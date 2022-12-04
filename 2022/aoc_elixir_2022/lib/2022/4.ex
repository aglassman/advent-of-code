import AOC

aoc 2022, 4 do
  def p1(input) do
    Enum.reduce(parse(input), 0, fn
      [a1, b1, a2, b2], acc  when a2 >= a1 and b2 <= b1 ->
        acc + 1
      [a1, b1, a2, b2], acc  when a1 >= a2 and b1 <= b2 ->
        acc + 1
      _, acc ->
        acc
    end)
  end

  def p2(input) do
    Enum.reduce(parse(input), 0, fn
      [a1, b1, a2, b2] = a, acc  when a2 <= b1 and a2 >= a1 ->
        acc + 1
      [a2, b2, a1, b1] = a, acc  when a2 <= b1 and a2 >= a1 ->
        acc + 1
      _, acc ->
        acc
    end)
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn assignments ->
      assignments
      |> Enum.map(&String.split(&1, "-"))
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
