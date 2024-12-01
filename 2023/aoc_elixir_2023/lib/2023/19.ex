import AOC

aoc 2023, 19 do
  @moduledoc """
  https://adventofcode.com/2023/day/19
  """

  def accepted?(part, workflows, step) do
    {_, rules, default} = List.keyfind!(workflows, step, 0)
    Enum.reduce_while(rules, default, fn rule, acc ->
      case rule.(part) do
        x when x in [:R, :A] -> x
        x -> x
      end
    end)
  end

  @doc """
      iex> p1(example_input())
    [bvh: {z, op}]
  """
  def p1(input) do
    [workflows, parts] = String.split(input, "\n\n")
    workflows = Enum.map(String.split(workflows, "\n"), fn line ->
      [[_, code] | rules] = Regex.scan(~r/([a-z]+)\{|([xmas]{1})([\>\<])([\d]+):([a-zA-Z])|,([a-zA-Z]+)\}/, line)
      {default, rules} = List.pop_at(rules, -1)
      default = List.last(default)
      rules = Enum.map(rules, fn [_, _, var, op, value, dest] ->
        value = String.to_integer(value)
        [var, op, dest] = Enum.map([var, op, dest], &String.to_atom/1)
        &(if op.(&1[var], value), do: dest)
      end)
      {String.to_atom(code), rules, String.to_atom(default)}
    end)

    parts = Enum.map(String.split(parts, "\n"), fn line ->
      Code.eval_string("%" <> String.replace(line, "=", ": ")) |> elem(0)
    end)

    [{start, _, _} | _] = workflows

    for part <- parts do
      {part, accepted?(part, workflows, start)}
    end
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
  end
end
