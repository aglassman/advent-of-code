import AOC

import String, only: [split: 2]

aoc 2022, 14 do
  @sand_point {500, 0}

  def p1(input) do
    input
    |> parse()
    |> drop_sand()
  end

  def p2(input) do
    grid = parse(input)

    max_y = grid
    |> Enum.map(fn {{x, y}, _} -> y end)
    |> Enum.max()

    max_y = max_y + 2

    grid = for x <- -1000..1000, reduce: grid do
      grid ->
        Map.put(grid, {x, max_y}, "#")
    end

    drop_sand(grid) + 1
  end

  def drop_sand(grid, dropped \\ 0) do

    case simulate(grid, @sand_point) do
      :halt ->
        dropped
      grid ->
        drop_sand(grid, dropped + 1)
    end
  end

  def simulate(grid, {_, 1000}), do: :halt

  def simulate(grid, {x, y} = p) do
    next = case grid[{x, y + 1}] do
      nil ->
        {x, y + 1}

      _ ->
        cond do
          grid[{x - 1, y + 1}] == nil -> {x - 1, y + 1}
          grid[{x + 1, y + 1}] == nil -> {x + 1, y + 1}
          true ->
            :halt
        end
    end

    case next do
      :halt ->
        if @sand_point == {x, y} do
          :halt
        else
          Map.put(grid, {x, y}, "o")
        end
      next ->
        simulate(grid, next)
    end
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> to_grid()
  end

  def parse_line(line) do
    "[{#{line}}]"
    |> String.replace(" -> ", "},{")
    |> Code.eval_string()
    |> elem(0)
  end

  def to_grid(rocks) do
    Enum.reduce(rocks, %{}, fn line, grid ->
      line
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(grid, &draw_line/2)
    end)
  end

  def draw_line([{x, y} = a,{x, y}], grid) do
    Map.put(grid, a, "#")
  end

  def draw_line([{x1, y1} = a, {x2, y2}], grid) do
    grid = Map.put(grid, a, "#")
    dx = direction(x1, x2)
    dy = direction(y1, y2)
    draw_line([{x1 + dx, y1 + dy}, {x2, y2}], grid)
  end

  def direction(a, a), do: 0
  def direction(a, b) when a < b, do: 1
  def direction(a, b) when a > b, do: -1

end
