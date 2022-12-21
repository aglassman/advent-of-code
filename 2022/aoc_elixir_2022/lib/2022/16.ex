import AOC

aoc 2022, 16 do
  def p1(input) do
    paths = parse(input)
    simulate(paths, paths["AA"], 30)
  end

  def p2(input) do
  end

  def simulate(paths, current, 0), do: paths

  def simulate(paths, current, minutes) do
    find_max(paths, current, minutes, %{})
  end



  def find_max(paths, %{id: current_id, open: is_open, rate: rate} = current, minutes, visited) do
    if Map.size(paths) == Map.size(visited) do

    else
      if Map.has_key?(current) do

      else
        visited
        |> Map.put(current_id, %{current | weight: calc_weight(current, minutes) })
      end
    end
  end

  def calc_weight(%{open: true}, _), do: 0
  def calc_weight(%{rate: rate}, minutes), do: rate * minutes

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, map ->
      [
        <<"Valve ", valve_id::binary-size(2), " has flow rate=", rate::binary>>,
        valves_string
      ] = String.split(line, "; ")
      valve = %{
        weight: nil,
        open: false,
        opened_at: nil,
        id: valve_id,
        rate: String.to_integer(rate),
        leads_to: valves_string |> trim_valves() |> String.split(", ")
      }
      Map.put(map, valve_id, valve)
    end)
  end

  def trim_valves("tunnels lead to valves " <> valves), do: valves
  def trim_valves("tunnel leads to valve " <> valves), do: valves

end
