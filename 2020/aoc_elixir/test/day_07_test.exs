defmodule Day07Test do
  use ExUnit.Case

  @example """
  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.
  """

  @example_2 """
  shiny gold bags contain 2 dark red bags.
  dark red bags contain 2 dark orange bags.
  dark orange bags contain 2 dark yellow bags.
  dark yellow bags contain 2 dark green bags.
  dark green bags contain 2 dark blue bags.
  dark blue bags contain 2 dark violet bags.
  dark violet bags contain no other bags.
  """

  test "example - part 1" do
    assert 4 = potential_containers(parse_to_bag_rules(@example), "shiny gold", true)
  end

  test "day 7 - part 1" do
    assert 185 =
             potential_containers(
               parse_to_bag_rules(File.read!("input/7.txt"), true),
               "shiny gold"
             )
  end

  test "example - part 2" do
    assert 32 = total_containers(parse_to_bag_rules(@example), "shiny gold", 1) - 1
    assert 126 = total_containers(parse_to_bag_rules(@example_2), "shiny gold", 1) - 1
  end

  test "day 7 - part 2" do
    assert 89084 =
             total_containers(parse_to_bag_rules(File.read!("input/7.txt")), "shiny gold", 1) - 1
  end

  def parse_to_bag_rules(input, reverse \\ false) do
    bag_rules = :digraph.new()

    for rule <- String.split(input, "\n", trim: true) do
      regex =
        ~r/(?<outer_color>[a-z ]+) bags contain|(?<inner_count>[\d]+) (?<inner_color>[a-z ]+) bag/

      [[_, outer_color] | contents] = Regex.scan(regex, rule, capture: :all)

      :digraph.add_vertex(bag_rules, outer_color)

      for [_, _, inner_count, inner_color] <- contents do
        :digraph.add_vertex(bag_rules, inner_color)

        if reverse do
          :digraph.add_edge(bag_rules, inner_color, outer_color, String.to_integer(inner_count))
        else
          :digraph.add_edge(bag_rules, outer_color, inner_color, String.to_integer(inner_count))
        end
      end
    end

    bag_rules
  end

  def potential_containers(bag_rules, bag_color) do
    Enum.count(:digraph_utils.reachable([bag_color], bag_rules)) - 1
  end

  def total_containers(bag_rules, bag_color, current_count) do
    count =
      :digraph.out_edges(bag_rules, bag_color)
      |> Enum.map(fn out_edge -> :digraph.edge(bag_rules, out_edge) end)
      |> Enum.map(fn {_, _, out_v, out_count} ->
        current_count * total_containers(bag_rules, out_v, out_count)
      end)
      |> Enum.sum()

    current_count + count
  end
end
