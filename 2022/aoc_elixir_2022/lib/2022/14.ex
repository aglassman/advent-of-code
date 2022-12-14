import AOC

import String, only: [split: 2, replace: 3]
import Code, only: [eval_string: 1]

aoc 2022, 14 do
  @sand_point {500, 0}

  def p1(input) do
    result = input
    |> parse()
    |> drop_sand()

    result - 1
  end

  def p2(input) do
    grid = parse(input)

    {{_, max_y}, _} = Enum.max_by(grid, fn {{x, y}, _} -> y end)
    max_y = max_y + 2

    grid
    |> draw_line([{-1000, max_y}, {1000, max_y}])
    |> drop_sand()
  end

  def drop_sand(:halt, dropped), do: dropped

  def drop_sand(grid, dropped \\ 0) do
    grid
    |> simulate(@sand_point)
    |> drop_sand(dropped + 1)
  end

  def simulate(grid, {x, y} = p) do
   cond do
      y > 1000 -> :halt
      grid[{x, y + 1}] == nil -> simulate(grid, {x, y + 1})
      grid[{x - 1, y + 1}] == nil -> simulate(grid, {x - 1, y + 1})
      grid[{x + 1, y + 1}] == nil -> simulate(grid, {x + 1, y + 1})
      @sand_point == p -> :halt
      true ->
        Map.put(grid, p, "#")
    end
  end

  def parse(input) do
    input
    |> split("\n")
    |> Enum.map(&parse_line/1)
    |> to_grid()
  end

  def parse_line(line) do
    "[{#{line}}]"
    |> replace(" -> ", "},{")
    |> eval_string()
    |> elem(0)
  end

  def to_grid(rocks) do
    Enum.reduce(rocks, %{}, fn line, grid ->
      line
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(grid, &draw_line(&2, &1))
    end)
  end

  def draw_line(grid, [{x, y} = a,{x, y}]) do
    Map.put(grid, a, "#")
  end

  def draw_line(grid, [{x1, y1} = a, {x2, y2} = b]) do
    grid
    |> Map.put(a, "#")
    |> draw_line([{x1 + d(x1, x2), y1 + d(y1, y2)}, b])
  end

  def d(a, a), do: 0
  def d(a, b) when a < b, do: 1
  def d(a, b) when a > b, do: -1

end
