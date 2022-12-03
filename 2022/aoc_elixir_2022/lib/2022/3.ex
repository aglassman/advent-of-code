import AOC

aoc 2022, 3 do
  def p1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn line ->
      line
      |> Enum.chunk_every(trunc(length(line) / 2))
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> Enum.at(0)
    end)
    |> Enum.join("")
    |> String.to_charlist()
    |> Enum.map(&ascii_map/1)
    |> Enum.sum()
  end

  def p2(input) do
    input
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(fn lines ->
      lines
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> Enum.at(0)
    end)
    |> Enum.join("")
    |> String.to_charlist()
    |> Enum.map(&ascii_map/1)
    |> Enum.sum()
  end

  def ascii_map(c) when c > 90, do: c - 96
  def ascii_map(c), do: c - 38
end
