defmodule Day13Test do
  use ExUnit.Case

  test "example" do
    assert 17 ==
             File.read!("input/13.example.txt")
             |> parse_input()
             |> then(fn {dot_set, [instruction | _]} ->
               {dot_set,  [instruction]}
             end)
             |> fold()
             |> MapSet.size()
  end

  test "day 13 - part 1" do
    assert 647 ==
             File.read!("input/13.txt")
             |> parse_input()
             |> then(fn {dot_set, [instruction | _]} ->
               {dot_set,  [instruction]}
             end)
             |> fold()
             |> MapSet.size()
  end

  test "example 2" do
    output = """
    #####
    #...#
    #...#
    #...#
    #####
    """

    assert output ==
             File.read!("input/13.example.txt")
             |> parse_input()
             |> fold()
             |> visualize()
  end

  test "day 13 - part 2" do
    output = """
    #..#.####...##.#..#...##.###...##....##
    #..#.#.......#.#..#....#.#..#.#..#....#
    ####.###.....#.####....#.#..#.#.......#
    #..#.#.......#.#..#....#.###..#.......#
    #..#.#....#..#.#..#.#..#.#.#..#..#.#..#
    #..#.####..##..#..#..##..#..#..##...##.
    """

    assert output ==
             File.read!("input/13.txt")
             |> parse_input()
             |> fold()
             |> visualize()
  end

  @doc """

  """
  def parse_input(input) do
    [dc, fi] = String.split(input, "\n\n", trim: true)
    {parse_dot_coords(dc), parse_fold_instructions(fi)}
  end

  # mapset of dots
  def parse_dot_coords(dot_coordinates_str) do
    dot_coordinates_str
    |> String.split("\n", trim: true)
    |> Enum.map(fn coord_str ->
      [x, y] = String.split(coord_str, ",", trim: true)
      {String.to_integer(x), String.to_integer(y)}
    end)
    |> MapSet.new()
  end

  # list of fold instructions
  def parse_fold_instructions(fold_instructions_str) do
    fold_instructions_str
    |> String.split("\n", trim: true)
    |> Enum.map(fn fold_str ->
      case fold_str do
        "fold along y=" <> y -> {:horizontal, String.to_integer(y)}
        "fold along x=" <> x -> {:vertical, String.to_integer(x)}
      end
    end)
  end

  def fold({dot_set, fold_instructions}) do
    fold_instructions
    |> Enum.reduce(dot_set, &fold/2)
  end

  def fold({:horizontal, line}, dot_set) do
    dot_set
    |> Enum.filter(fn {x, y} -> y > line end)
    |> Enum.reduce(dot_set, fn {x, y} = dot, folded_set ->
      folded_set
      |> MapSet.delete(dot)
      |> MapSet.put({x, abs(y - (line * 2))})
    end)
  end

  def fold({:vertical, line}, dot_set) do
    dot_set
    |> Enum.filter(fn {x, y} -> x > line end)
    |> Enum.reduce(dot_set, fn {x, y} = dot, folded_set ->
      folded_set
      |> MapSet.delete(dot)
      |> MapSet.put({abs(x - (line * 2)), y})
    end)
  end

  def visualize(dot_set) do
    {:ok, pid} = StringIO.open("visualize")

    [xs, ys] = dot_set
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)

    x_max = Enum.max(xs)
    y_max = Enum.max(ys)

    IO.inspect({x_max, y_max})

    for y <- 0..y_max, x <- 0..x_max do
      # IO.inspect({x, y})
      if MapSet.member?(dot_set, {x, y}) do
        IO.write(pid, "#")
      else
        IO.write(pid, ".")
      end

      if(x == x_max) do
        IO.write(pid, "\n")
      end
    end

    {_, output} = StringIO.contents(pid)
    IO.puts(output)
    output
  end

end
