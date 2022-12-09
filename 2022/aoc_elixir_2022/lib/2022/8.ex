import AOC

aoc 2022, 8 do
  def p1(input) do
    trees = parse(input)
    visible_exterior_trees(trees) + visible_interior_trees(trees)
  end

  def p2(input) do
    input
    |> parse()
    |> scenic_distances()
    |> Enum.max()
  end

  def visible_exterior_trees({x_size, y_size, _}) do
    y_size * 2 + (x_size - 2) * 2
  end

  @directions [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]

  def visible_interior_trees({x_size, y_size, grid}) do
    visible_trees =
      for x <- 1..(x_size - 2),
          y <- 1..(y_size - 2),
          Enum.any?(@directions, &vis?(grid[{x, y}], grid, {x, y}, &1)) do
        {x, y}
      end

    length(visible_trees)
  end

  def scenic_distances({x_size, y_size, grid}) do
    for x <- 1..(x_size - 2), y <- 1..(y_size - 2) do
      Enum.reduce(@directions, 1, &(dis(grid[{x, y}], grid, {x, y}, &1) * &2))
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
