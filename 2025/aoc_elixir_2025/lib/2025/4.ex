import AOC

aoc 2025, 4 do
  def p1(input) do
    grid = grid(input)

    grid
    |> Stream.filter(fn {_, v} -> v == "@" end)
    |> Stream.filter(fn {pos, _} -> surrounding_roll_count(grid, pos) < 4 end)
    |> Enum.count()
  end

  def surrounding_roll_count(grid, {x, y}) do
    for {dx, dy} <- [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}] do
      {x + dx, y + dy}
    end
    |> Stream.filter(fn {nx, ny} -> Map.get(grid, {nx, ny}) == "@" end)
    |> Enum.count()
  end

  def p2(input) do
    input
    |> grid()
    |> remove_rolls()
    |> Enum.count()
  end

  def remove_rolls(grid, removed \\ []) do
    to_remove =
      grid
      |> Stream.filter(fn {_, v} -> v == "@" end)
      |> Stream.filter(fn {pos, _} -> surrounding_roll_count(grid, pos) < 4 end)
      |> Enum.to_list()

    if Enum.empty?(to_remove) do
      removed
    else
      to_remove
      |> Enum.reduce(grid, fn {pos, _}, grid -> Map.put(grid, pos, ".") end)
      |> remove_rolls(removed ++ to_remove)
    end
  end

  def grid(input) do
    lines =
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
      end)

    for {line, y} <- Enum.with_index(lines), {v, x} <- Enum.with_index(line), into: %{} do
      {{x, y}, v}
    end
  end
end
