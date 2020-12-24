defmodule Day20Test do
  use ExUnit.Case

  test "example - part 1" do
    assert 20_899_048_083_289 =
             "input/20-example.txt"
             |> File.read!()
             |> tiles()
             |> part_1()
  end

  test "day 20 - part 1" do
    assert 7_492_183_537_913 =
             "input/20.txt"
             |> File.read!()
             |> tiles()
             |> part_1()
  end

  test "example - part 2" do
    assert 273 =
             "input/20-example.txt"
             |> File.read!()
             |> tiles()
             |> part_2()
  end

  def tiles(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn tile ->
      [header, body] = String.split(tile, ":")
      "Tile" <> tile_id = header
      tile_id = tile_id |> String.trim() |> String.to_integer()
      {tile_id, body}
    end)
  end

  def part_2(tiles) do
    IO.inspect(tiles)
    edge_map = edge_map(tiles) |> IO.inspect()
    shared_edge_map = shared_edges(edge_map) |> IO.inspect()
    tiles |> Enum.map(&to_edge_tuple/1) |> IO.inspect()
    corners = corners(shared_edge_map)
    [start | _] = corners
  end

  def part_1(tiles) do
    edge_map(tiles)
    |> shared_edges()
    |> corners()
    |> Enum.reduce(&*/2)
  end

  @sea_monster """
  ..................#.
  #....##....##....###
  .#..#..#..#..#..#...
  """

  def monster_mask() do
    @sea_monster
    |> body_lines()
    |> to_int()
  end

  def flip(body_lines) do
  end

  def corners(shared_edge_map) do
    shared_edge_map
    |> Enum.filter(fn {tile_id, edge_ids} -> length(edge_ids) == 2 end)
    |> Enum.map(fn {tile_id, _} -> tile_id end)
  end

  def edge_map(tiles) do
    tiles
    |> Enum.map(&to_edge_tuple/1)
    |> Enum.reduce(%{}, fn {tile_id, edges}, edge_map ->
      edges
      |> Enum.reduce(
        edge_map,
        &Map.update(&2, &1, [tile_id], fn tile_ids -> [tile_id | tile_ids] end)
      )
    end)
  end

  def shared_edges(edge_map) do
    edge_map
    |> Enum.reduce(%{}, fn {edge_id, tiles}, shared_edge_map ->
      if length(tiles) > 1 do
        Enum.reduce(
          tiles,
          shared_edge_map,
          &Map.update(&2, &1, tiles, fn edge_shared ->
            List.flatten(tiles ++ edge_shared)
            |> :lists.usort()
            |> Enum.reject(fn tile_id -> tile_id == &1 end)
          end)
        )
      else
        shared_edge_map
      end
    end)
  end

  def to_edge_tuple({tile_id, body}) do
    body_lines = body_lines(body)
    body_columns = body_columns(body_lines)

    [n | _] = body_lines
    s = Enum.at(body_lines, -1)
    [w | _] = body_columns
    e = Enum.at(body_columns, -1)

    {tile_id, to_int([n, e, s, w]) ++ to_int_inv([n, e, s, w])}
  end

  def to_edge_tuple({tile_id, body}) do
    body_lines = body_lines(body)
    body_columns = body_columns(body_lines)

    [n | _] = body_lines
    s = Enum.at(body_lines, -1)
    [w | _] = body_columns
    e = Enum.at(body_columns, -1)

    {tile_id, to_int([n, e, s, w]) ++ to_int_inv([n, e, s, w])}
  end

  def body_lines(body) do
    body
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.replace(".", "0")
      |> String.replace("#", "1")
    end)
  end

  def body_columns(body_lines) do
    body_lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join/1)
  end

  def to_int(list), do: Enum.map(list, fn x -> Integer.parse(x, 2) |> elem(0) end)

  def to_int_inv(list),
    do: Enum.map(list, fn x -> x |> String.reverse() |> Integer.parse(2) |> elem(0) end)
end
