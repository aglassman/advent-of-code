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
      [a1, b1, a2, _b2], acc  when a2 <= b1 and a2 >= a1 ->
        acc + 1
      [a2, _b2, a1, b1], acc  when a2 <= b1 and a2 >= a1 ->
        acc + 1
      _, acc ->
        acc
    end)
  end

  def parse(input) do
    Regex.scan(~r/(([\d]+)-([\d]+)),(([\d]+)-([\d]+))/, input)
    |> Enum.map(fn [_, _, a, b, _ ,c, d] ->
      Enum.map([a, b, c, d], &String.to_integer/1)
    end)
  end
end
