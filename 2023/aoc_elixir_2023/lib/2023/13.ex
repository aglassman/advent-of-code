import AOC

aoc 2023, 13 do
  @moduledoc """
  https://adventofcode.com/2023/day/13
  """

  def parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
  end

  def rotate(map) do
    map
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(fn tup -> Tuple.to_list(tup) |> Enum.join() end)
  end

  @doc """
  [w, x, y, z, z, y, x, t]
  [x, y, z, z, y, x, t], [w]
  [y, z, z, y, x, t], [x, w]
  [z, z, y, x, t], [y, x, w]
  [z, y, x, t], [z, y, x, w]
  """
  def mirror_point(size, rows, visited \\ [], mirror_points \\ [])

  def mirror_point(size, [], _, []), do: {0, 0}
  def mirror_point(size, [], _, mirror_points), do:  Enum.max_by(mirror_points, fn {_, i} -> i end)

  def mirror_point(size, [a, a | t], visited, mirror_points) do

    left = [a | visited]
    right = [a | t]

    matching = [left, right]
    |> Enum.zip()
    |> Enum.reduce_while(0, fn
      {a, a}, count -> {:cont, count + 1}
      _, count -> {:halt, count}
    end)

    mirror_point(size, right, left, [{length(left), matching} | mirror_points])
  end

  def mirror_point(size, [h | t], visited, mirror_points), do: mirror_point(size, t, [h | visited], mirror_points)

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    maps = parse(input)

    splits = Enum.map(maps, fn map ->
      v_map = rotate(map)
      candidates = [v: mirror_point({:v, length(v_map)}, v_map), h: mirror_point({:h, length(map)}, map)] |> IO.inspect()
      Enum.max_by(candidates, fn {_, {_, i}} -> i end)
    end) |> IO.inspect()

    splits
    |> Enum.map(fn
      {:v, {i, _}} -> i
      {:h, {i, _}} -> 100 * i
    end)
    |> Enum.sum()

  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
  end
end
