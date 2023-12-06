import AOC

aoc 2023, 5 do
  @moduledoc """
  https://adventofcode.com/2023/day/5
  """

  def parse_section("seeds: " <> seeds) do
    {"seeds", string_to_ints(seeds)}
  end

  def parse_section(section) do
    [name, map_rows] = String.split(section, " map:\n")

    map_rows =
      map_rows
      |> String.split("\n")
      |> Enum.map(&string_to_ints/1)

    {name, map_rows}
  end

  def string_to_ints(string) do
    string
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def to_ranges([dest, src, length]) do
    size = length - 1
    [src..(src + size), dest..(dest + size)]
  end

  def determine_value({map, entries}, value) do
    case Enum.find_value(entries, fn entry -> lookup(entry, value) end) do
      nil ->
        value

      mapped_value ->
        mapped_value
    end
  end

  def lookup([dest_start, src_start, length] = entry, value) do
    res =
      if value >= src_start and value < src_start + length do
        dest_start + (value - src_start)
      else
        nil
      end

    res
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    almanac =
      input
      |> String.split("\n\n")
      |> Enum.map(&parse_section/1)

    [{"seeds", seeds} | maps] = almanac

    locations =
      for seed <- seeds do
        result =
          Enum.reduce(maps, seed, fn map, value ->
            determine_value(map, value)
          end)
      end

    Enum.min(locations)
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    almanac =
      input
      |> String.split("\n\n")
      |> Enum.map(&parse_section/1)

    [{"seeds", seeds} | maps] = almanac

    seed_ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] -> a..(a + b - 1) end)
      |> Flow.from_enumerable()
      |> Flow.map(fn seed_range ->
        min =
          seed_range
          |> Stream.map(fn seed ->
            Enum.reduce(maps, seed, fn map, value ->
              determine_value(map, value)
            end)
          end)
          |> Enum.min()

        IO.inspect("seed range complete")
        min
      end)
      |> Enum.min()
  end
end
