import AOC
import AocUtils


aoc 2023, 16 do
  @moduledoc """
  https://adventofcode.com/2023/day/16
  """

  def next(".", _grid, {{dx, dy}, {x, y} = beam_loc, energy_map}) do
    {:cont, {{dx, dy}, {x + dx, y + dy}, Map.update(energy_map, beam_loc, 1, &(&1 + 1))}}
  end

  def next("|", grid, {{dx, dy}, {x, y} = beam_loc, energy_map}) do
    if dy == 0 do
      energy_map = Map.update(energy_map, beam_loc, 1, &(&1 + 1))
      em_1 = energy_map(grid, {{0, -1}, {x, y - 1}, energy_map})

      energy_map = Map.merge(energy_map, em_1, fn
        "beams", a, b -> MapSet.union(a, b)
        _, a, b -> a + b
      end)

      em_2 = energy_map(grid, {{0, 1}, {x, y + 1}, energy_map})

      energy_map = Map.merge(energy_map, em_2, fn
        "beams", a, b -> MapSet.union(a, b)
        _, a, b -> a + b
      end)

      {:halt, energy_map}
    else
      {:cont, {{dx, dy}, {x + dx, y + dy}, Map.update(energy_map, beam_loc, 1, &(&1 + 1))}}
    end
  end

  def next("-", grid, {{dx, dy}, {x, y} = beam_loc, energy_map}) do
    if dx == 0 do
      energy_map = Map.update(energy_map, beam_loc, 1, &(&1 + 1))
      em_1 = energy_map(grid, {{-1, 0}, {x - 1, y}, energy_map})

      energy_map = Map.merge(energy_map, em_1, fn
        "beams", a, b -> MapSet.union(a, b)
        _, a, b -> a + b
      end)

      em_2 = energy_map(grid, {{1, 0}, {x + 1, y}, energy_map})

      energy_map = Map.merge(energy_map, em_2, fn
        "beams", a, b -> MapSet.union(a, b)
        _, a, b -> a + b
      end)

      {:halt, energy_map}
    else
      {:cont, {{dx, dy}, {x + dx, y + dy}, Map.update(energy_map, beam_loc, 1, &(&1 + 1))}}
    end
  end

  def next("\\", _grid, {{dx, dy}, {x, y} = beam_loc, energy_map}) do
    {dx, dy} = {dy, dx}
    {:cont, {{dx, dy}, {dx + x, dy + y}, Map.update(energy_map, beam_loc, 1, &(&1 + 1))}}
  end

  def next("/", _grid, {{dx, dy}, {x, y} = beam_loc, energy_map}) do
    {dx, dy} = {dy * -1, dx * -1}
    {:cont, {{dx, dy}, {dx + x, dy + y}, Map.update(energy_map, beam_loc, 1, &(&1 + 1))}}
  end

  def next(nil, _, {_, _, em}), do: {:halt, em}

  def energy_map(grid, state \\ {{1, 0}, {0, 0}, %{"beams" => MapSet.new()}}) do
    Enum.reduce_while(Stream.cycle(0..11000000000), state, fn
      i, {dir, beam_loc, em} = state ->
        beam = Map.get(em, "beams")
        if MapSet.member?(beam, {beam_loc, dir}) do
          {:halt, em}
        else
          beam = MapSet.put(beam, {beam_loc, dir})
          em = Map.put(em, "beams", beam)
          current = grid_loc(grid, beam_loc)
#          IO.inspect({MapSet.size(beam), {beam_loc, dir}, current})
          next(current, grid, {dir, beam_loc, em})
        end

    end)
  end

  @doc """
      iex> p1(example_input())
      AOC.IEx.p1e(year: 2023, day: 16)
  """
  def p1(input) do
    {grid, width, height} = mirror_grid = grid(input)

     energy_map(mirror_grid)
     |> Map.keys()
     |> length()

  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    {grid, width, height} = mirror_grid = grid(input)


    edges = List.flatten([
      (for x <- 0..(width - 1), do: {{x, 0}, {0, 1}}),
      (for x <- 0..(width - 1), do: {{x, height - 1}, {0, -1}}),
      (for y <- 0..(height - 1), do: {{0, y}, {1, 0}}),
      (for y <- 0..(height - 1), do: {{width - 1, y}, {-1, 0}}),
    ]) |> Enum.uniq()

    edges
    |> Flow.from_enumerable()
    |> Flow.map(fn {loc, dir} ->
      energy_map(mirror_grid, {dir, loc, %{"beams" => MapSet.new()}})
      |> Map.keys()
      |> length()
      |> IO.inspect()
    end)
    |> Enum.max()
  end
end
