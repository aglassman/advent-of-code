import AOC

aoc 2022, 12 do
  def p1(input) do
    %{graph: graph, start: s, end: e} = parse(input)
    length(:digraph.get_short_path(graph, s, e)) - 1
  end

  def p2(input) do
    %{graph: graph, start: s, end: e} = map = parse(input)

    map =
      map
      |> Enum.filter(fn {_, v} -> v in [?a, ?a - 1] end)
      |> Enum.map(fn {start, _} -> :digraph.get_short_path(graph, start, e) end)
      |> Enum.reject(&(&1 == false))
      |> Enum.map(&(length(&1) - 1))
      |> Enum.min()
  end

  def parse(input) do
    graph = :digraph.new()

    map =
      for {line, y} <- Enum.with_index(String.split(input, "\n")),
          {c, x} <- Enum.with_index(String.graphemes(line)),
          reduce: %{} do
        map ->
          case c do
            "S" ->
              :digraph.add_vertex(graph, {x, y}, ?a - 1)

              map
              |> Map.put(:start, {x, y})
              |> Map.put({x, y}, ?a - 1)

            "E" ->
              :digraph.add_vertex(graph, {x, y}, ?a - 1)

              map
              |> Map.put(:end, {x, y})
              |> Map.put({x, y}, ?z + 1)

            c ->
              <<i::utf8>> = c
              :digraph.add_vertex(graph, {x, y}, i)

              Map.put(map, {x, y}, i)
          end
      end

    for {{cx, cy}, current} <- map do
      [{cx + 1, cy}, {cx - 1, cy}, {cx, cy + 1}, {cx, cy - 1}]
      |> Enum.map(fn {x, y} -> {{x, y}, Map.get(map, {x, y})} end)
      |> Enum.each(fn
        {{nx, ny}, next} when next - current <= 1 ->
          :digraph.add_edge(graph, {cx, cy}, {nx, ny})

        _ ->
          nil
      end)
    end

    Map.put(map, :graph, graph)
  end
end
