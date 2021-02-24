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
    assert 4 =
             @example
             |> parse_to_bag_rules(true)
             |> potential_containers("shiny gold")
  end

  test "day 7 - part 1" do
    assert 185 =
             File.read!("input/7.txt")
             |> parse_to_bag_rules(true)
             |> potential_containers("shiny gold")
  end

  test "example - part 2" do
    assert 32 = @example
                |> parse_to_bag_rules()
                |> total_containers("shiny gold", 1)
                |> Kernel.-(1) # off by one!
    
    assert 126 = total_containers(parse_to_bag_rules(@example_2), "shiny gold", 1) - 1
  end

  test "day 7 - part 2" do
    assert 89084 =
             File.read!("input/7.txt")
             |> parse_to_bag_rules()
             |> total_containers("shiny gold", 1)
             |> Kernel.-(1) # off by one!
  end

  @doc """
  Oh boy, this one was fun.  I thought doing this via :digraph would make it easier
  but I'm sure it took much longer because of it!  Overall, it was still fun to write.
  """
  def parse_to_bag_rules(input, reverse \\ false) do
    bag_rules = :digraph.new()

    # Process each line, and create the appropriate vertices and edges
    for rule <- String.split(input, "\n", trim: true) do
      # light [_, 'red'] bags contain ['1', 'bright white'] bag, ['2', 'muted yellow'] bags.
      regex =
        ~r/(?<outer_color>[a-z ]+) bags contain|(?<inner_count>[\d]+) (?<inner_color>[a-z ]+) bag/

      [[_, outer_color] | contents] = Regex.scan(regex, rule, capture: :all)

      # Create a vertex for the outer bag color
      # The vertext name is the bag color
      :digraph.add_vertex(bag_rules, outer_color)

      # For each inner bag...
      for [_, _, inner_count, inner_color] <- contents do
        # create the inner bag vertex if it does not exist yet.
        :digraph.add_vertex(bag_rules, inner_color)

        if reverse do
          # Create an edge between two bags with an edge label of the count.
          :digraph.add_edge(bag_rules, inner_color, outer_color, String.to_integer(inner_count))
        else
          :digraph.add_edge(bag_rules, outer_color, inner_color, String.to_integer(inner_count))
        end
      end
    end

    bag_rules
  end

  # This is where :digraph becomes super useful!
  def potential_containers(bag_rules, bag_color) do
    Enum.count(:digraph_utils.reachable([bag_color], bag_rules)) - 1
  end

  # I thought there would be a nifty way to use :digraph_utils to
  # do this traversal for me, but I didn't figure it out.  There may
  # be a way to do it!
  # Depth First Recursive Traversal
  # Calculates container count on its way out
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
