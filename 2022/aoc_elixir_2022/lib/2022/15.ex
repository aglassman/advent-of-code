import AOC
import String, only: [to_integer: 1]
aoc 2022, 15 do
  def p1(input) do
    row = 2000000

    search_row = input
    |> parse()
    |> Enum.reduce(MapSet.new(), fn [x1, y1, x2, y2] = coords, set ->
      range = distance(coords)
      for x <- (x1 - range)..(x1 + range), distance([x1, y1, x, row]) <= range, reduce: set do
        set ->
          MapSet.put(set, {x, row})
      end
    end)

    MapSet.size(search_row) - 1
  end

  def p2(input) do
    tuning_frequency = 4000000
    locations = parse(input)

    ranges = locations
    |> Enum.reduce(%{}, fn [x, y | _] = coords, map ->
      Map.put(map, {x, y}, distance(coords))
    end)
    |> IO.inspect()

    locations
    |> Enum.map(fn [x, y | _] = coords ->
      loc_range = distance(coords)
      close = Enum.filter(ranges, fn {{x2, y2}, r} ->
        range2 = distance([x, y, x2, y2]) == (r + loc_range )
      end)
      {{x, y}, close}
    end)
    |> Enum.filter(fn {{x, y}, close} ->
      Enum.count(close) >= 3
    end)


  end

  def distance([x1, y1, x2, y2]) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  @line_regex ~r/Sensor at x=(-?[\d]+), y=(-?[\d]+): closest beacon is at x=(-?[\d]+), y=(-?[\d]+)/

  def parse(input) do
    for [_ | coordinates] <- Regex.scan(@line_regex, input), into: [] do
      Enum.map(coordinates, &to_integer/1)
    end
  end
end
