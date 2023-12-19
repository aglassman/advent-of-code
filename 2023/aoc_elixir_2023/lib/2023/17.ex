import AOC
import AocUtils

aoc 2023, 17 do
  @moduledoc """
  https://adventofcode.com/2023/day/17
  """

  # Final square reached
  def min_path({_, width, height}, {x, y}, path, visited) when x == (width - 1) and y == width - 1 do
    path
  end

  # Too far in one direction
  def min_path(mirror_grid, {x, y}, [{_, {a, b}}, {_, {a, b}}, {_, {a, b}} | tail], visited) do

  end

  def min_path(mirror_grid, loc, path, visited) do

  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    {grid, width, height} = mirror_grid = int_grid(input)

    min_path(mirror_grid, {0, 0}, [{0, 0}], MapSet.new())

  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
  end
end
