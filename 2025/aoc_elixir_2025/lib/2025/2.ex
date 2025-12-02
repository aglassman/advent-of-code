import AOC

aoc 2025, 2 do
  def p1(input) do
    for range <- parse(input), id <- range do
      mask_p = trunc(digits(id) / 2)
      mask = trunc(:math.pow(10, mask_p))
      top = trunc(id / mask)
      top_mask = top * mask
      bottom = id - top_mask
      {id, {top, bottom}, top != bottom}
    end
    |> Stream.reject(fn {_, _, valid?} -> valid? end)
    |> Stream.map(fn {id, _, _} -> id end)
    |> Enum.sum()
  end

  def p2(input) do
    for range <- parse(input),
        id <- range,
        chunk <- 1..trunc(digits(id) / 2),
        chunk != 0 and id >= 10 do
      candidate =
        id
        |> to_string()
        |> String.graphemes()
        |> Enum.chunk_every(chunk)

      {_, invalid?} =
        Enum.reduce_while(candidate, {List.first(candidate), true}, fn
          x, {y, _} when x == y -> {:cont, {x, true}}
          _, _ -> {:halt, {nil, false}}
        end)

      {id, invalid?}
    end
    |> Stream.filter(fn {_, invalid?} -> invalid? end)
    |> Stream.map(fn {id, _} -> id end)
    |> Enum.uniq()
    |> Enum.sum()
  end

  def digits(int), do: (:math.log10(int) |> trunc()) + 1

  def parse(input) do
    input
    |> String.split(",")
    |> Stream.map(&String.split(&1, "-"))
    |> Stream.map(fn [a, b] -> Range.new(String.to_integer(a), String.to_integer(b)) end)
  end
end
