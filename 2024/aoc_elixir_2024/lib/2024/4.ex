import AOC

aoc 2024, 4 do
  @moduledoc """
  https://adventofcode.com/2024/day/4
  """

  def grid(input) do
    map = input
          |> String.split("\n")
          |> Enum.map(&String.graphemes/1)
    [row | _] = map
    rows = length(map)
    columns = length(row)

    entries = for {row, r} <- Enum.with_index(map), {v, c} <- Enum.with_index(row) do
      {{r, c}, v}
    end

    {Map.new(entries), rows, columns}
  end

  def vertical({word_grid, rows, columns}) do
    for col <- 0..(columns - 1), row <- 0..(rows - 1) do
      c = word_grid[{row, col}]
      if row == rows - 1 do
        [c, "\n"]
      else
        c
      end
    end
  end


  def diagonals({word_grid, rows, columns}) do
    primary_diagonals =
      for start <- 0..(columns + rows - 2), reduce: [] do
        acc ->
          diagonal =
            for x <- 0..columns - 1, y = start - x, y >= 0, y < rows, do: word_grid[{x, y}] || "\n"

          [diagonal |> :erlang.iolist_to_binary() | acc]
      end

    secondary_diagonals =
      for start <- -(rows - 1)..(columns - 1), reduce: [] do
        acc ->
          diagonal =
            for x <- 0..columns - 1, y = x - start, y >= 0, y < rows, do: word_grid[{x, y}] || "\n"

          [diagonal |> :erlang.iolist_to_binary() | acc]
      end

    primary_diagonals ++ secondary_diagonals
  end

  def count(input) do
    Regex.scan(~r/XMAS|SAMX/, input)
    |> IO.inspect()
    |> Enum.count()
  end

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    word_grid = grid(input) |> IO.inspect()

    h = count(input)
    v = vertical(word_grid) |> IO.inspect() |> :erlang.iolist_to_binary() |> count()
    d = diagonals(word_grid) |> Enum.map(&count/1) |> Enum.sum()
    IO.inspect([h, v, d, h + v + d])
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(_input) do

  end
end
