import AOC

aoc 2023, 14 do
  @moduledoc """
  https://adventofcode.com/2023/day/14
  """

  def tilt(list) do
    list
    |> String.split("#")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.sort(&1, :desc))
    |> Enum.join("#")
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    tilted = input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(fn tup -> Tuple.to_list(tup) |> Enum.join() end)
    |> Enum.map(&tilt/1)
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> IO.inspect()

    row_count = length(tilted)

    for {row, i} <- Enum.with_index(tilted), reduce: 0 do
      load ->
        rocks = Tuple.to_list(row) |> Enum.filter(&(&1 == "O")) |> length()
        load + (rocks * (row_count - i))
    end


  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do

    start = input |> String.split("\n")

    result = for i <- 1..1_000_000_000, reduce: start do
      start ->
        # North
        north = start
                 |> Enum.map(&String.graphemes/1)
                 |> Enum.zip()
                 |> Enum.map(fn tup -> Tuple.to_list(tup) |> Enum.join() end)
                 |> Enum.map(&tilt/1)

        # West
        west = north
        |> Enum.map(&String.graphemes/1)
        |> Enum.zip()
        |> Enum.map(fn tup -> Tuple.to_list(tup) |> Enum.join() end)
        |> Enum.map(&tilt/1)

        # South
        south = west
               |> Enum.map(&String.graphemes/1)
               |> Enum.zip()
               |> Enum.map(fn tup -> Tuple.to_list(tup) |> Enum.join() end)
               |> Enum.map(&tilt/1)

        # East
        east = south
               |> Enum.map(&String.graphemes/1)
               |> Enum.zip()
               |> Enum.map(fn tup -> Tuple.to_list(tup) |> Enum.join() end)
               |> Enum.map(&tilt/1)

        result = east
          |> Enum.map(&String.graphemes/1)
          |> Enum.zip()

        row_count = length(result)

        load = for {row, i} <- Enum.with_index(result), reduce: 0 do
          load ->
            rocks = Tuple.to_list(row) |> Enum.filter(&(&1 == "O")) |> length()
            load + (rocks * (row_count - i))
        end
        IO.inspect([i: i, load: load])

        east
    end




  end
end
