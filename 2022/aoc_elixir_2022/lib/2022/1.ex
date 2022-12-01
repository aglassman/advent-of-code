import AOC

aoc 2022, 1 do
  def p1 do
    input_string
    |> String.split("\n")
    |> Enum.reduce({0, 0}, fn
      "", {max, current} when current > max ->
        {current, 0}
      "", {max, _} ->
        {max, 0}
      x_str, {max, current} ->
        {max, current + String.to_integer(x_str)}
    end)
  end

  def p2 do
    {elfs, elf} = input_string
    |> String.split("\n")
    |> Enum.reduce({[], 0}, fn
      "", {elfs, current} ->
        {[current | elfs], 0}
      x_str, {elfs, current} ->
        {elfs, current + String.to_integer(x_str)}
    end)

    [elf | elfs]
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()

  end

end
