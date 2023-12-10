import AOC

aoc 2023, 10 do
  @moduledoc """
  https://adventofcode.com/2023/day/10
  """

  def to_map(input) do
    map = input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    [row | _] = map
    width = length(row)
    height = length(map)
    {map, width, height}
  end

  def loc(map, {x, y}) do
    Enum.at(Enum.at(map, y), x)
  end

  def find_loop({map, width, height} = map_details, start, {x, y} = current_loc, current_path) do
    p_loc = List.first(current_path)
    candidates = candidates(map_details, current_loc)
#    IO.inspect(candidates, lable: :cand)
    [{next_coord, next_symbol} | _] = f_cand = Enum.reject(candidates, fn {loc, _} -> p_loc != nil and loc == p_loc end)

#    IO.inspect(%{start: start, cur: current_loc, cur_p: current_path, cand: candidates, f_cand: f_cand})

    if next_coord == start do
      [current_loc | current_path]
    else
      find_loop(map_details, start, next_coord, [current_loc | current_path])
    end
  end

  def candidates({map, width, height}, {x, y} = current_loc) do

    c = case loc(map, current_loc) do
      "|" -> [{{x, y + 1}, loc(map, {x, y + 1})}, {{x, y - 1}, loc(map, {x, y - 1})}]
      "-" -> [{{x - 1, y}, loc(map, {x - 1, y})}, {{x + 1, y}, loc(map, {x + 1, y})}]
      "L" -> [{{x, y - 1}, loc(map, {x, y - 1})}, {{x + 1, y}, loc(map, {x + 1, y})}]
      "J" -> [{{x, y - 1}, loc(map, {x, y - 1})}, {{x - 1, y}, loc(map, {x - 1, y})}]
      "F" -> [{{x, y + 1}, loc(map, {x, y + 1})}, {{x + 1, y}, loc(map, {x + 1, y})}]
      "7" -> [{{x - 1, y}, loc(map, {x - 1, y})}, {{x, y + 1}, loc(map, {x, y + 1})}]
      "S" -> [{{x - 1, y}, loc(map, {x - 1, y})}, {{x + 1, y}, loc(map, {x + 1, y})}, {{x, y + 1}, loc(map, {x, y + 1})}, {{x, y - 1}, loc(map, {x, y - 1})},]
      _ -> []
    end

    Enum.reject(
      c,
      fn {{x, y}, v} ->
        !(v in ~w(| - L J 7 F S)) or x < 0 or x >= width or y < 0 or y >= height
      end)
  end

  # expand out to all unvisited spaces.
  def explore({map, width, height} = map_details, loop_map, visited, {x, y} = current_loc) do
    to_explore = [{x + 1, y}, {x - 1, y}, {x, y - 1}, {x, y + 1}]
    |> Stream.reject(fn {x, y} -> x < 0 or x >= width or y < 0 or y >= height end)
    |> Stream.reject(&MapSet.member?(visited, &1))
    |> Stream.reject(&MapSet.member?(loop_map, &1))
    |> Enum.to_list()

    visited = MapSet.put(visited, current_loc)

    for next <- to_explore, reduce: visited do
      v ->
        MapSet.union(v, explore(map_details, loop_map, v, next))
    end
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    {map, width, height} = map_details = to_map(input)

    start = for x <- 0..(width - 1), y <- 0..(height - 1), reduce: nil do
      nil -> if loc(map, {x, y}) == "S" do {x, y} else nil end
      start -> start
    end

    length(find_loop(map_details, start, start, [])) / 2
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    {map, width, height} = map_details = to_map(input)

    start = for x <- 0..(width - 1), y <- 0..(height - 1), reduce: nil do
      nil -> if loc(map, {x, y}) == "S" do {x, y} else nil end
      start -> start
    end

    loop = find_loop(map_details, start, start, [])

    # For each edge, expand outwards, and count.
    # Add all counted "outside" spaces to a hashmap to prevent duplicate visits.
    # From the total spaces, subtract outside spaces, and loop spaces.

    edges = List.flatten([
      (for x <- 0..(width - 1), do: {x, 0}),
      (for x <- 0..(width - 1), do: {x, height - 1}),
      (for y <- 0..(height - 1), do: {0, y}),
      (for y <- 0..(height - 1), do: {width - 1, y}),
    ]) |> Enum.uniq()

    loop_map = MapSet.new(loop)

    visited = Enum.reduce(edges, MapSet.new(), fn edge, visited ->
      if MapSet.member?(loop_map, edge) or MapSet.member?(visited, edge) do
        visited
      else
        MapSet.union(visited, explore(map_details, loop_map, visited, edge))
      end
    end)

    total_size = width * height

    IO.inspect([total_size, MapSet.size(visited), MapSet.size(loop_map)])
    IO.inspect(loop)
    total_size - MapSet.size(visited) - MapSet.size(loop_map)

  end
end
