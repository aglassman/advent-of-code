import AOC

aoc 2023, 3 do
  @moduledoc """
  https://adventofcode.com/2023/day/3
  """

  def parse_schematic(input) do
    lines = input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)

    result = for {line, y} <- Enum.with_index(lines), {char, x} <- Enum.with_index(line), reduce: {%{}, {0,0}, [], []} do
      {schematic, num_start, num, nums} ->
        {nums, num, num_start} = case Integer.parse(char) do
          {i, _} ->
            num_start = if num_start == nil do {x, y} else num_start end
            {nums, num ++ [i], num_start}
          _ ->
            case num do
              [] ->
                {nums, [], nil}
              _ ->
                {[{num_start, num} | nums], [], nil}
            end
        end

        {
          Map.put(schematic, {x, y}, char),
          num_start,
          num,
          nums
        }
    end

    {schematic, num_start, num, nums} = result
    {schematic, nums}
  end

  def is_part_number?({{x, y}, num}, schematic) do
    {min_x, max_x, min_y, max_y} = min_max(x, y, length(num))

    checks = for y <- min_y..max_y, x <- min_x..max_x do
      !(Map.get(schematic, {x, y}) in [nil, "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."])
    end

    Enum.any?(checks)
  end

  def min_max(x, y, len) do
    {x - 1, x + len, y - 1, y + 1}
  end

  def arr_to_int({_, num}) do
    num
    |> Enum.join()
    |> String.to_integer()
  end

  def arr_to_int(num) when is_list(num) do
    num
    |> Enum.join()
    |> String.to_integer()
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    {schematic, nums} = parse_schematic(input)
    nums
    |> Enum.filter(&is_part_number?(&1, schematic))
    |> Enum.map(&arr_to_int/1)
    |> Enum.sum()
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    {schematic, nums} = parse_schematic(input)

    gear_locations = for {{x1, y1}, num} <- nums, reduce: %{} do
      gear_map ->
        {min_x, max_x, min_y, max_y} = min_max(x1, y1, length(num))

        for y2 <- min_y..max_y, x2 <- min_x..max_x, reduce: gear_map do
          gear_map ->
            case Map.get(schematic, {x2, y2})do
              "*" ->
                Map.update(gear_map, {x2, y2}, [num], fn gear_locs -> [num | gear_locs] end)
              _ ->
                gear_map
            end
        end

    end

    gear_locations
    |> Enum.filter(fn {_ , nums} -> length(nums) == 2 end)
    |> Enum.map(fn {_, nums} ->  nums |> Enum.map(&arr_to_int/1) |> Enum.product()  end)
    |> Enum.sum()

  end
end
