import AOC

aoc 2022, 19 do
  def p1(input) do
    blueprints = parse(input)

    blueprints
    |> Enum.map(&requirement_tree/1)
#    |> Enum.map(&max_geodes(&1, 24, %{"ore" => 1}))

  end

  def p2(input) do
  end

  def requirement_tree(blueprint) do
    requirement_tree(blueprint, "geode", [])
  end

  def requirement_tree(blueprint, "ore", tree), do: tree

  def requirement_tree(blueprint, resource, tree) do
    blueprint[resource]
    |> Enum.reduce([], fn {resource, amount}, tree ->
      [requirement_tree(resource) | tree]
    end)
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&to_blueprint/1)
  end

  def to_blueprint("Blueprint " <> rest) do
    [id_str, costs] = String.split(rest, ":")

    costs = costs
    |> String.split(". ")
    |> Enum.map(&to_cost/1)
    |> Map.new()

    blueprint = %{id: String.to_integer(id_str)}
    Map.merge(blueprint, costs)
  end

  def to_cost(cost_str) do
    [_, type, costs] = Regex.run(~r/Each (.*) robot costs (.*)/, cost_str)
    costs = costs
    |> String.split(" and ")
    |> Enum.reduce(%{}, fn cost, acc ->
      [amount, type] = String.split(cost, " ")
      Map.put(acc, type, String.to_integer(amount))
    end)
    {type, costs}
  end
end
