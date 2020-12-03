defmodule Day03Test do
  use ExUnit.Case
  use Bitwise
  doctest AocElixir

  @example """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """

  test "example - part 1" do

    {map, width, height} = input = parse_input(@example)
    assert 11 == width
    assert 11 == height
    assert 11 * 11 == map
                      |> Enum.count()
    assert 7 == encountered_trees(input, {3, 1})
  end

  test "day 3 - part 1" do
    input = File.read!("input/3.txt")

    {map, width, height} = input = parse_input(input)
    assert 31 == width
    assert 323 == height
    assert 31 * 323 == map
                       |> Enum.count()
    assert 220 == encountered_trees(input, {3, 1})
  end

  @slopes [{1, 1}, {3, 1},{5, 1}, {7, 1}, {1, 2}]

  test "example - part 2" do
    {map, width, height} = input = parse_input(@example)

    assert 336 == @slopes
                  |> Enum.map(&(encountered_trees(input, &1)))
                  |> Enum.reduce(fn x, acc -> x * acc end)

  end

  test "day 3 - part 2" do
    {map, width, height} = input = parse_input(File.read!("input/3.txt"))

    assert 2138320800 == @slopes
                  |> Enum.map(&(encountered_trees(input, &1)))
                  |> Enum.reduce(fn x, acc -> x * acc end)

  end

  def parse_input(input) do
    [line_1 | _] = lines = input
                           |> String.split("\n")
                           |> Enum.reject(&("" == &1))

    height = Enum.count(lines)

    width = line_1
            |> String.trim()
            |> String.length()

    map = lines
          |> Stream.map(&String.trim/1)
          |> Stream.map(&String.graphemes/1)
          |> Stream.flat_map(fn x -> x end)
          |> Enum.into([])

    {map, width, height}
  end

  @tree "#"

  def encountered_trees({map, width, height}, {right, down}) do
    locations_to_check = for i <- 0..(height - 1), do: (i * down * width) + rem(i * right, width)

    locations_to_check
    |> Enum.map(fn location -> Enum.at(map, location) end)
    |> Enum.reject(&(&1 != @tree))
    |> Enum.count()
  end



end