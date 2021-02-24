defmodule Day03Test do
  use ExUnit.Case

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

    # validating that the expected size of the input matches
    # the parsed input
    assert 11 * 11 ==
             map
             |> Enum.count()

    # count the number of encountered trees for the given slope.
    assert 7 == encountered_trees(input, {3, 1})
  end

  test "day 3 - part 1" do
    input = File.read!("input/3.txt")

    {map, width, height} = input = parse_input(input)
    assert 31 == width
    assert 323 == height

    assert 31 * 323 ==
             map
             |> Enum.count()

    assert 220 == encountered_trees(input, {3, 1})
  end

  # define multiple slopes
  @slopes [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

  test "example - part 2" do
    {map, width, height} = input = parse_input(@example)

    # fun use of map reduce
    assert 336 ==
             @slopes
             |> Enum.map(&encountered_trees(input, &1))
             |> Enum.reduce(&*/2)
  end

  test "day 3 - part 2" do
    {map, width, height} = input = parse_input(File.read!("input/3.txt"))

    assert 2_138_320_800 ==
             @slopes
             |> Enum.map(&encountered_trees(input, &1))
             |> Enum.reduce(&*/2)
  end

  @doc """
  Takes the string input, and returns a tuple of
  {map, width, height}
  map is a list of "." or "#" strings.
  """
  def parse_input(input) do
    [line_1 | _] =
      lines =
      input
      |> String.split("\n")
      |> Enum.reject(&("" == &1))

    height = Enum.count(lines)

    width =
      line_1
      |> String.trim()
      |> String.length()

    map =
      lines
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.graphemes/1)
      |> Stream.flat_map(fn x -> x end)
      |> Enum.into([])

    {map, width, height}
  end

  @doc """
  We calculate the offset for each iteration, as a row.
  [ ".", ".", ".",
    ".", ".", "#",
    "#", ".", ".",
  ]

  I was actually surprised this provided the correct answer with a "down" slope
  greater than one, but I didn't try to figure out if the math works out, or I just got
  lucky with the input!
  """
  def encountered_trees({map, width, height}, {right, down} = slope) do
    0..(height - 1)
    |> Enum.filter(&(Enum.at(map, calculate_offset(&1, width, slope)) == "#"))
    |> Enum.count()
  end

  defp calculate_offset(iteration, width, {right, down}) do
    iteration * down * width + rem(iteration * right, width)
  end
end
