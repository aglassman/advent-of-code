import AOC

aoc 2022, 5 do
  def p1(input) do
    {stacks, instructions} = parse(input)

    stacks
    |> move(instructions)
    |> tops()
  end

  def p2(input) do
    {stacks, instructions} = parse(input, nil)

    stacks
    |> move(instructions)
    |> tops()
  end

  def move(stacks, []) do
    stacks
  end

  def move(stacks, [instruction | instructions]) do
    stacks
    |> move(instruction)
    |> move(instructions)
  end

  def move(stacks, %{amount: 0}) do
    stacks
  end

  def move(stacks, %{crane_capacity: c, amount: a, from: f, to: t} = i) do
    {to_move, old_stack} = Enum.split(stacks[f], c || a)
    new_stack = to_move ++ stacks[t]

    stacks
    |> Map.put(f, old_stack)
    |> Map.put(t, new_stack)
    |> move(%{i | amount: a - (c || a)})
  end

  def tops(stacks) do
    stacks
    |> Enum.sort_by(fn {i, _} -> -i end)
    |> Enum.reduce([], fn {_, [a | _]}, acc -> [a | acc] end)
    |> Enum.join("")
  end

  def parse(input, crane_capacity \\ 1) do
    [stacks, instructions] = String.split(input, "\n\n")

    stacks =
      Regex.scan(~r/\[(\D{1})\]|   [\n ]/, stacks)
      |> Enum.map(fn
        [_] ->
          nil

        [_, c] ->
          c
      end)
      |> Enum.chunk_every(9)
      |> Enum.reverse()
      |> Enum.reduce(fn a, b ->
        a
        |> Enum.zip(b)
        |> Enum.map(&Tuple.to_list/1)
      end)
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {stack, i}, acc ->
        stack = stack |> List.flatten() |> Enum.reject(&is_nil/1)
        Map.put(acc, i, stack)
      end)

    instructions =
      ~r/move ([\d]+) from ([\d]+) to ([\d]+)/
      |> Regex.scan(instructions)
      |> Enum.map(fn [_, a, f, t] ->
        %{
          amount: String.to_integer(a),
          from: String.to_integer(f),
          to: String.to_integer(t),
          crane_capacity: crane_capacity
        }
      end)

    {stacks, instructions}
  end
end
