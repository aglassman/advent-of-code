defmodule Day10Test do
  use ExUnit.Case

  test "part 1" do
    grid = input() |> to_grid_map()

    grid = Enum.map(grid, fn {location, _collisions} ->
      {location,  collisions(grid, location) |> Enum.count()}
    end)
    {location, max} = Enum.max_by(grid, fn {location, count} -> count end)

    assert {28, 26} == location
    assert max == 267
  end

  test "part 2" do
    grid = input() |> to_grid_map()

    grid = for {location, _collisions} <- grid, into: %{} do
      {location,  collisions(grid, location)}
    end

    frequencies = grid
    |> Map.get({28, 26})
    |> Enum.sort_by(fn {theta, count} -> theta end, :desc)

    start = (:math.pi / 2) |> Float.round(5)

    sorted_frequencies = find_start(frequencies, start)

    frequency_state = sorted_frequencies |> Map.new()

    {_, updated_frequencies, last_frequency} = sorted_frequencies
    |> Stream.cycle()
    |> Enum.reduce_while({0, frequency_state, nil}, fn
        {freq, c}, {200, frequency_state, last} ->
          {:halt, {freq, frequency_state, freq}}
        {freq, c}, {count, frequency_state, last} ->
          case Map.get(frequency_state, freq) do
            [] ->
              IO.inspect([freq, nil, nil, count, last], label: :c)
              {:cont, {count, Map.delete(frequency_state, freq), last}}

            [loc | []] ->
              IO.inspect([freq, loc, [], count + 1, last], label: :b)
              {:cont, {count + 1, Map.delete(frequency_state, freq), freq}}

            [loc | locs] ->
              IO.inspect([freq, loc, locs, count + 1, last], label: :a)
              {:cont, {count + 1, Map.put(frequency_state, freq, locs), freq}}
          end
    end)

#    IO.inspect(frequencies, limit: :infinity)
    IO.inspect(sorted_frequencies, limit: :infinity)
    IO.inspect(Map.get(frequency_state, last_frequency))
    IO.inspect([last_frequency, Map.get(updated_frequencies, last_frequency)])

  end

  def find_start([{a, _} = at | [{b, _} = bt | _tail] = tail], start, new_list \\ []) when a > start and b <= start, do: tail ++ [at | new_list]

  def find_start([{a, _} = at | tail], start, new_list), do: find_start(tail, start, [at | new_list])

  def collisions(grid, {x1, y1}) do
    grid
    |> Enum.map(fn {{x2, y2}, _} ->
      {:math.atan2(y2 - y1, x2 - x1) |> Float.round(5), {x2, y2}}
    end)
    |> Enum.reduce(%{}, fn {freq, loc}, collisions->
      Map.update(collisions, freq, [loc], fn locs -> locs ++ [loc] end)
    end)
  end

  def to_grid_map(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {line, row} ->
      parsed = line
      |> String.graphemes()
      |> Enum.with_index()
      {row, parsed}
    end)
    |> Enum.reduce(%{}, fn {row, columns}, acc ->
      for {space, col} <- columns, space != ".", into: %{} do
        {{row, col}, %{}}
      end
      |> Map.merge(acc)
    end)
  end

  def input(), do: """
  #....#.....#...#.#.....#.#..#....#
  #..#..##...#......#.....#..###.#.#
  #......#.#.#.....##....#.#.....#..
  ..#.#...#.......#.##..#...........
  .##..#...##......##.#.#...........
  .....#.#..##...#..##.....#...#.##.
  ....#.##.##.#....###.#........####
  ..#....#..####........##.........#
  ..#...#......#.#..#..#.#.##......#
  .............#.#....##.......#...#
  .#.#..##.#.#.#.#.......#.....#....
  .....##.###..#.....#.#..###.....##
  .....#...#.#.#......#.#....##.....
  ##.#.....#...#....#...#..#....#.#.
  ..#.............###.#.##....#.#...
  ..##.#.........#.##.####.........#
  ##.#...###....#..#...###..##..#..#
  .........#.#.....#........#.......
  #.......#..#.#.#..##.....#.#.....#
  ..#....#....#.#.##......#..#.###..
  ......##.##.##...#...##.#...###...
  .#.....#...#........#....#.###....
  .#.#.#..#............#..........#.
  ..##.....#....#....##..#.#.......#
  ..##.....#.#......................
  .#..#...#....#.#.....#.........#..
  ........#.............#.#.........
  #...#.#......#.##....#...#.#.#...#
  .#.....#.#.....#.....#.#.##......#
  ..##....#.....#.....#....#.##..#..
  #..###.#.#....#......#...#........
  ..#......#..#....##...#.#.#...#..#
  .#.##.#.#.....#..#..#........##...
  ....#...##.##.##......#..#..##....
  """

end