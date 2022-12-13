import AOC

aoc 2022, 10 do
  def p1(input) do
    {_, output} =
      input
      |> parse()
      |> process(1, 220, 1, [])

    output
    |> Enum.filter(fn %{cycle: c} -> c in [20, 60, 100, 140, 180, 220] end)
    |> Enum.map(fn %{s: s} -> s end)
    |> Enum.sum()
  end

  def p2(input) do
    {_, output} =
      input
      |> parse()
      |> process(1, 240, 1, [])

    output
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.with_index(&1))
    |> Enum.map(fn line ->
      blank_line = 0..39 |> Enum.map(fn _ -> " " end)

      line
      |> Enum.reduce(blank_line, fn {%{x: x}, i}, line_buffer ->
        if x in [i, i + 1, i - 1] do
          line_buffer
          |> List.insert_at(i, "#")
        else
          line_buffer
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def process([], cycle, max_cycles, x, output) do
    {x, output}
  end

  def process(instructions, cycle, max_cycles, x, output) when cycle > max_cycles do
    {x, output}
  end

  def process([instruction | instructions], cycle, max_cycles, x, output) do
    {cycles, x, output} =
      case instruction do
        {:noop, cycles, _} ->
          {cycles, x, [%{cycle: cycle, x: x, s: cycle * x} | output]}

        {:addx, cycles, v} ->
          {cycles, x + v,
           [
             %{cycle: cycle + 1, x: x, s: (cycle + 1) * x}
             | [%{cycle: cycle, x: x, s: cycle * x} | output]
           ]}
      end

    process(instructions, cycle + cycles, max_cycles, x, output)
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn
      "noop" ->
        {:noop, 1, nil}

      "addx " <> x ->
        {:addx, 2, String.to_integer(x)}
    end)
  end
end
