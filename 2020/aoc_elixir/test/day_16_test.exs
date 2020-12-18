defmodule Day16Test do
  use ExUnit.Case

  @example """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """

  @example_2 """
  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9
  """

  test "example - part 1" do
    assert 71 = part_1(@example)
  end

  test "day 16 - part 1" do
    assert 21956 = part_1(File.read!("input/16.txt"))
  end

  test "example - part 2 - valid tickets" do
    assert %{valid_tickets: [[7, 3, 47]]} =
             @example
             |> parse()
             |> discard_invalid()
  end

  test "example - part 2 - identified" do
    assert ["row", "class", "seat"] =
             @example_2
             |> parse()
             |> discard_invalid()
             |> determine_field_order()
  end

  test "day 16 - part 2" do
    assert 3_709_435_214_239 = part_2(File.read!("input/16.txt"))
  end

  def part_1(input) do
    input
    |> parse()
    |> find_invalid()
    |> Enum.sum()
  end

  def part_2(input) do
    %{your_ticket: your_ticket} = notes = parse(input)

    field_order =
      notes
      |> discard_invalid()
      |> determine_field_order()

    your_ticket
    |> Enum.zip(field_order)
    |> Enum.filter(&match?({_, "departure " <> _}, &1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&*/2)
  end

  def determine_field_order(%{valid_tickets: valid_tickets, rules: rules}) do
    valid_tickets
    |> identify_candidates(rules)
    |> resolve()
  end

  def identify_candidates(valid_tickets, rules) do
    valid_tickets
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.with_index()
    |> Enum.reduce(
      %{},
      fn {field_set, i}, candidate_map ->
        Map.put(candidate_map, i, candidates(field_set, rules))
      end
    )
  end

  def resolve(candidate_map) do
    resolved =
      candidate_map
      |> Enum.filter(fn {i, field_set} -> MapSet.size(field_set) == 1 end)
      |> Enum.map(fn {_, field_set} -> field_set end)
      |> Enum.reduce(&MapSet.union/2)

    if Enum.count(candidate_map) == MapSet.size(resolved) do
      Enum.map(candidate_map, fn {_, resolved} -> Enum.at(resolved, 0) end)
    else
      candidate_map
      |> Enum.map(fn {i, candidates} ->
        cond do
          MapSet.size(candidates) == 1 -> {i, candidates}
          true -> {i, MapSet.difference(candidates, resolved)}
        end
      end)
      |> Map.new()
      |> resolve()
    end
  end

  def candidates(field_set, rules) do
    rules
    |> Enum.filter(fn {name, rule} ->
      Enum.all?(field_set, &in_range?(&1, rule))
    end)
    |> Enum.map(fn {name, _} -> name end)
    |> MapSet.new()
  end

  def discard_invalid(%{nearby_tickets: nearby_tickets, rules: rules} = notes) do
    valid_tickets = Enum.filter(nearby_tickets, &contains_all_valid_values(&1, rules))
    Map.put(notes, :valid_tickets, valid_tickets)
  end

  def contains_all_valid_values(ticket, rules) when is_list(ticket) do
    Enum.reduce(ticket, true, fn tic_val, acc -> acc && contains_valid_value(tic_val, rules) end)
  end

  def find_invalid(%{nearby_tickets: nearby_tickets, rules: rules}) do
    nearby_tickets
    |> List.flatten()
    |> Enum.reject(&contains_valid_value(&1, rules))
  end

  def contains_valid_value(ticket, rules) when is_list(ticket) do
    Enum.reduce(ticket, false, fn tic_val, acc -> acc || contains_valid_value(tic_val, rules) end)
  end

  def contains_valid_value(val, rules) do
    Enum.reduce(rules, false, fn {_, rule}, acc -> acc || in_range?(val, rule) end)
  end

  def in_range?(val, {a, b}) do
    in_range?(val, a) || in_range?(val, b)
  end

  def in_range?(val, [min, max]) do
    min <= val && val <= max
  end

  def parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.reduce(%{}, &t_parse(&1, &2))
  end

  def t_parse("your ticket:\n" <> your_ticket, state) do
    Map.put(state, :your_ticket, ticket(your_ticket))
  end

  def t_parse("nearby tickets:\n" <> nearby_tickets, state) do
    nearby_tickets =
      nearby_tickets
      |> String.split("\n", trim: true)
      |> Enum.map(&ticket/1)

    Map.put(state, :nearby_tickets, nearby_tickets)
  end

  def t_parse(input, state) do
    input
    |> String.split("\n")
    |> Enum.map(&rule/1)
    |> Enum.reduce(state, fn rule, state ->
      Map.update(state, :rules, [rule], fn rules -> [rule | rules] end)
    end)
  end

  def rule(field) do
    %{"n" => name, "a" => a, "b" => b} =
      Regex.named_captures(~r/(?<n>.+): (?<a>.+) or (?<b>.+)/, field)

    {name, {range(a), range(b)}}
  end

  def ticket(ticket) do
    ticket
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def range(input) do
    input
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> Enum.into([])
  end
end
