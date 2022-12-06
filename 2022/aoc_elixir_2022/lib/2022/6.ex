import AOC

aoc 2022, 6 do
  def p1(input) do
    size = 4

    {_, i} =
      input
      |> String.graphemes()
      |> Stream.chunk_every(size, 1)
      |> Stream.map(&Enum.uniq/1)
      |> Stream.map(&length/1)
      |> Stream.with_index()
      |> Enum.find(fn {uniq_items, _} -> uniq_items == size end)

    i + size
  end

  def p2(input) do
    size = 14

    {_, i} =
      input
      |> String.graphemes()
      |> Stream.chunk_every(size, 1)
      |> Stream.map(&Enum.uniq/1)
      |> Stream.map(&length/1)
      |> Stream.with_index()
      |> Enum.find(fn {uniq_items, _} -> uniq_items == size end)

    i + size
  end
end
