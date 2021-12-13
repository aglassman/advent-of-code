defmodule Day11Test do
  use ExUnit.Case

  test "example" do
    assert 1656 ==
             File.read!("input/11.example.txt")
             |> parse_input()
             |> simulate()
             |> solve_pt1()
  end

  test "day 11 - part 1" do
    assert 0 ==
             File.read!("input/11.txt")
             |> parse_input()
  end

  test "example 2" do
    assert 0 ==
             File.read!("input/11.example.txt")
             |> parse_input()
  end

  test "day 11 - part 2" do
    assert 0 ==
             File.read!("input/11.txt")
             |> parse_input()
  end

  @doc """
  returns a map of all locations in an N x N square
  Top row is {0, 0}, {1, 0} ...
  Bottom row is {N, 0}, {N, 1}, ..., {N, N}
  %{
    {x, y} => energy
  }
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {power, x} -> {{x, y}, %{power: power, count: 0}} end)
    end)
    |> Map.new()
  end

  def solve_pt1(power_map) do
    power_map
    |> Map.values()
    |> Enum.map(fn %{count: c} -> c end)
    |> Enum.sum()
  end

  def simulate(power_map, 0), do: power_map

  def simulate(power_map, iterations \\ 5) do
    print_it(iteration, updated_map)

    updated_map =
      power_map
      |> Enum.map(fn {position, %{power: p, count: c}} ->
        {position, %{power: p + 1, count: c}}
      end)
      |> Enum.reduce(power_map, fn {position, %{power: p}} = entry, acc ->
        if(p == 9) do
          flash(acc, entry)
        else
          acc
        end
      end)
      |> Enum.map(fn
        {position, %{power: 9, count: c}} ->
          {position, %{power: 0, count: c + 1}}

        x ->
          x
      end)
      |> Map.new()

    simulate(updated_map, iterations - 1)
  end

  def flash(power_map, {position, %{power: 9}}) do
    Enum.reduce(
      adjacent(position, power_map),
      power_map,
      fn adj_position, acc ->
        flash(acc, adj_position)
      end
    )
  end

  def flash(power_map, position) do
    if Map.has_key?(power_map, position) do
      updated_map =
        Map.update(power_map, position, 0, fn x = %{power: p} -> %{x | power: p + 1} end)

      new_entry = %{power: p} = Map.get(updated_map, position)

      if p == 9 do
        flash(updated_map, {position, new_entry})
      else
        updated_map
      end
    else
      power_map
    end
  end

  def adjacent({x, y}, power_map) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
    |> Enum.map(fn position ->
      case Map.get(power_map, position) do
        nil -> nil
        val -> position
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def print_it(iteration, power_map) do
    IO.inspect(iteration)

    Enum.sort_by(power_map, fn {{x, y}, power} ->
      x < Y
    end)
  end
end
