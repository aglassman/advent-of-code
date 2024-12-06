import AOC

aoc 2024, 5 do
  @moduledoc """
  https://adventofcode.com/2024/day/5
  """

  def parse(input) do
    [rules, page_lists] = String.split(input, "\n\n")

    rules = rules
      |> String.split("\n")
      |> Enum.map(&String.split(&1, "|"))

    page_lists = page_lists
      |> String.split("\n")
      |> Enum.map(&Map.new(Enum.with_index(String.split(&1, ","))))


    {rules, page_lists}
  end

  def valid?(page_map, rules) do
    Enum.all?(rules, fn [a, b] ->
      case {page_map[a], page_map[b]} do
        {a_pos, b_pos} when is_integer(a_pos) and is_integer(b_pos) ->
          a_pos < b_pos

        _ ->
          true
      end
    end)
  end

  def find_middle(page_map) do
    middle = (floor(map_size(page_map) / 2))
    {m, _} = Enum.find(page_map, fn {_, i} -> i == middle end)
    String.to_integer(m)
  end

  def reorder(page_map, rules) do
    reordered = Enum.reduce(rules, page_map, fn [a, b], page_map ->
      case {page_map[a], page_map[b]} do
        {a_pos, b_pos} when is_integer(a_pos) and is_integer(b_pos) and a_pos > b_pos ->
          page_map
          |> Map.put(a, b_pos)
          |> Map.put(b, a_pos)

        _ ->
          page_map
      end
    end)

    if valid?(reordered, rules) do
      reordered
    else
      reorder(reordered, rules)
    end
  end

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    {rules, page_maps} = parse(input)

    page_maps
    |> Stream.filter(&valid?(&1, rules))
    |> Stream.map(&find_middle/1)
    |> Enum.sum()
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    {rules, page_maps} = parse(input)

    page_maps
    |> Stream.reject(&valid?(&1, rules))
    |> Stream.map(&reorder(&1, rules))
    |> Stream.map(&find_middle/1)
    |> Enum.sum()
  end
end
