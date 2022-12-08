import AOC

aoc 2022, 8 do
  def p1(input) do
    input
    |> parse()
    |> visible_trees()
  end

  def p2(input) do
    input
    |> parse()
    |> scenic_distances()
    |> Enum.max()
  end

  @directions [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]

  def visible_trees({x_size, y_size, grid}) do
    for x <- 0..(x_size - 1),
        y <- 0..(y_size - 1),
        Enum.any?(@directions, &vis?(grid[{x, y}], grid, {x, y}, &1)),
        reduce: 0 do
      acc ->
        acc + 1
    end
  end

  def scenic_distances({x_size, y_size, grid}) do
    for x <- 1..(x_size - 2), y <- 1..(y_size - 2) do
      for dir <- @directions, reduce: 1 do
        acc ->
          acc * dis(grid[{x, y}], grid, {x, y}, dir)
      end
    end
  end

  def vis?(height, grid, {x, y}, {dx, dy}) do
    case grid[{x + dx, y + dy}] do
      nil ->
        true

      h when h >= height ->
        false

      _ ->
        vis?(height, grid, {x + dx, y + dy}, {dx, dy})
    end
  end

  def dis(height, grid, {x, y}, {dx, dy}, distance \\ 0) do
    case grid[{x + dx, y + dy}] do
      nil ->
        distance

      h when h >= height ->
        distance + 1

      _ ->
        dis(height, grid, {x + dx, y + dy}, {dx, dy}, distance + 1)
    end
  end

  def parse(input) do
    lines = String.split(input, "\n")
    y_size = length(lines)
    x_size = String.length(Enum.at(lines, 0))

    parsed =
      Enum.map(lines, fn line ->
        line
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      end)

    grid =
      for {line, y} <- Enum.with_index(parsed), {value, x} <- Enum.with_index(line), into: %{} do
        {{x, y}, value}
      end

    {x_size, y_size, grid}
  end
end
