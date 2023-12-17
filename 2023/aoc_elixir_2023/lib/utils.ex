defmodule AocUtils do


  @doc """
  Parse multi line input into a list of lists of graphemes.
  Returns a tuple of {grid, width, height}
  """
  def grid(input) do
    map = input
          |> String.split("\n")
          |> Enum.map(&String.graphemes/1)
    [row | _] = map
    width = length(row)
    height = length(map)
    {map, width, height}
  end

  @doc """
  Returns the grapheme at the given {x, y} coordinate in the grid.
  """
  def grid_loc({map, width, height}, {x, y}, allow_wrap \\ false) do
    if allow_wrap do
      Enum.at(Enum.at(map, y), x)
    else
      if x >= 0 and x < width and y >= 0 and y < height do
        Enum.at(Enum.at(map, y), x)
      else
        nil
      end
    end
  end

end