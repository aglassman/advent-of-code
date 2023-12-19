import AOC

aoc 2023, 18 do
  @moduledoc """
  https://adventofcode.com/2023/day/18
  """

  def parse(input) do
    instructions = Regex.scan(~r/([RDLU]{1}) ([\d]+) \((#.*?)\)/, input)
    Enum.map(instructions, fn [_, direction, distance, color] ->
      {direction, String.to_integer(distance), color}
    end)
  end

  def parse_2(input) do
    instructions = Regex.scan(~r/([RDLU]{1}) ([\d]+) \((#.*?)\)/, input)
    Enum.map(instructions, fn [_, direction_o, distance_o, color] ->
      {distance, _} = Integer.parse(String.slice(color, 1, 5), 16)
      direction = case String.slice(color, 6, 6) do
        "0" -> "R"
        "1" -> "D"
        "2" -> "L"
        "3" -> "U"
      end

      {direction, distance, {{distance_o, distance}, {direction_o, direction}}}
    end) |> IO.inspect()
  end

  def draw(loop, {min_x, max_x}, {min_y, max_y}, visited) do
    IO.write("---- loop ----\n")
    for y <- max_y..min_y do
      for x <- min_x..max_x do
        case Map.get(loop, {x, y}) do
          nil ->
            if MapSet.member?(visited, {x, y}) do
              IO.write("o")
            else
              IO.write(".")
            end
          color ->
            IO.write("#")
        end
      end
      IO.write("\n")
    end
  end

  def unvisited_adj(ets, {x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.reject(fn {x, y} -> :ets.member(ets, {x, y}) end)
  end

  def fill([], ets), do: ets

  def fill([{x, y} | tail], ets) do
    :ets.insert_new(ets, {{x, y}, nil})
    unvisited = unvisited_adj(ets, {x, y})
    fill(unvisited ++ tail, ets)
  end

  @doc """
      {x, y, z}
  """
  def p1(input) do
    instructions = parse(input)
    {_, loop} = Enum.reduce(instructions, {{0, 0}, %{}}, fn instruction, {{x, y}, plan} ->
      {direction, distance, color} = instruction
      for i <- 1..distance, reduce: {{x, y}, plan} do
        {{x, y}, plan} ->
          case direction do
            "R" ->
              {{x + 1, y}, Map.put(plan, {x + 1, y}, color)}
            "L" ->
              {{x - 1, y}, Map.put(plan, {x - 1, y}, color)}
            "U" ->
              {{x, y + 1}, Map.put(plan, {x, y + 1}, color)}
            "D" ->
              {{x, y - 1}, Map.put(plan, {x, y - 1}, color)}
          end
      end
    end)

    {start_x, start_y} = loop |> Map.keys() |> Enum.min()
    {min_x, max_x} = xr = loop |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = yr = loop |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    table = :ets.new(:plan, [:set, :protected])
    Enum.each(loop |> Map.keys(), fn {x, y} -> :ets.insert(table, {{x, y}, nil}) end)
    fill([{start_x + 1, start_y + 1}], table) |> :ets.info(:size)


  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    instructions = parse_2(input)

    {_, loop} = Enum.reduce(instructions, {{0, 0}, %{}}, fn instruction, {{x, y}, plan} ->
      {direction, distance, color} = instruction
      for i <- 1..distance, reduce: {{x, y}, plan} do
        {{x, y}, plan} ->
          case direction do
            "R" ->
              {{x + 1, y}, Map.put(plan, {x + 1, y}, color)}
            "L" ->
              {{x - 1, y}, Map.put(plan, {x - 1, y}, color)}
            "U" ->
              {{x, y + 1}, Map.put(plan, {x, y + 1}, color)}
            "D" ->
              {{x, y - 1}, Map.put(plan, {x, y - 1}, color)}
          end
      end
    end)

    {start_x, start_y} = loop |> Map.keys() |> Enum.min()
    {min_x, max_x} = xr = loop |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = yr = loop |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    Task.start(fn ->
      table = :ets.new(:plan, [:set, :protected, :named_table]) |> IO.inspect()
      Enum.each(loop |> Map.keys(), fn {x, y} -> :ets.insert(table, {{x, y}, nil}) end)
      fill([{start_x + 1, start_y + 1}], table) |> :ets.info(:size)
    end)

  end
end
