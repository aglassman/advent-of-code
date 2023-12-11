import AOC

aoc 2023, 11 do
  @moduledoc """
  https://adventofcode.com/2023/day/11
  """

  def parse(input) do
    [row | _] = rows = String.split(input, "\n")
    width = String.length(row)
    height = length(rows)
    map_str = Enum.join(rows)
    galaxies = Regex.scan(~r/#/, map_str, return: :index) |> List.flatten() |> IO.inspect()
    galaxies = Enum.map(galaxies, fn {i, _} -> {rem(i, width), trunc(i / height)} end)
    {map_str, width, height, galaxies}
  end

  def find_expanses(width, height, galaxies) do
    {find_expanse(galaxies, 0, 0..(width - 1)), find_expanse(galaxies, 1, 0..(height - 1))}
  end

  def find_expanse(list, i, range) do
    list
    |> Enum.map(&elem(&1, i))
    |> MapSet.new()
    |> then(&MapSet.difference(MapSet.new(range), &1))
  end

  def combination([], comb), do: comb
  def combination([h | t], comb), do: combination(t, Enum.map(t, fn i -> {h, i} end) ++ comb)

  def distance({{ga_x, ga_y}, {gb_x, gb_y}}, {x_expanses, y_expanses}, expand_by \\ 1) do
    {min_x, max_x} = Enum.min_max([ga_x, gb_x])
    {min_y, max_y} = Enum.min_max([ga_y, gb_y])

    distance = (max_x - min_x) + (max_y - min_y)

    distance = Enum.reduce(x_expanses, distance, fn x, d ->
      if x > min_x and x < max_x do d + expand_by else d end
    end)

    distance = Enum.reduce(y_expanses, distance, fn y, d ->
      if y > min_y and y < max_y do d + expand_by else d end
    end)

    distance
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    {map, width, height, galaxies} = parse(input)
    expanses = find_expanses(width, height, galaxies)
    connections = combination(galaxies, [])
    Enum.map(connections, &distance(&1, expanses))
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    {map, width, height, galaxies} = parse(input)
    expanses = find_expanses(width, height, galaxies)
    connections = combination(galaxies, [])
    Enum.map(connections, &distance(&1, expanses, 999_999))
  end
end
