import AOC
import String, only: [split: 2, trim: 1]
import Enum, only: [map: 2, sum: 1]

aoc 2023, 4 do
  @moduledoc """
  https://adventofcode.com/2023/day/4
  """

  def parse(input) do
    input
    |> split("\n")
    |> map(&split(&1, ":"))
    |> map(fn [card, line] ->
      [winning, guess] = split(line, "|")
      winning = Enum.reject(split(trim(winning), " "), &(&1 == ""))
      guess = Enum.reject(split(trim(guess), " "), &(&1 == ""))
      {card, winning, guess}
    end)
  end

  def win_check({card, winning, guess}) do
    matches = MapSet.intersection(MapSet.new(winning), MapSet.new(guess))
    match_count = MapSet.size(matches)

    points =
      if match_count > 0 do
        points = :math.pow(2, match_count - 1)
      else
        0
      end

    {card, matches, match_count, points}
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    input
    |> parse()
    |> map(&elem(win_check(&1), 3))
    |> sum()
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    cards = parse(input)

    card_map =
      cards
      |> map(&win_check/1)
      |> Enum.with_index(1)
      |> Map.new(fn {{_, _, matches, points}, key} -> {key, {matches, points, 1}} end)

    card_map =
      for i <- 1..Map.size(card_map), reduce: card_map do
        card_map ->
          {matches, points, t_mult} = Map.get(card_map, i)

          if matches > 0 do
            for z <- (i + 1)..(i + matches), reduce: card_map do
              card_map ->
                Map.update(card_map, z, nil, fn {matches, points, mult} ->
                  {matches, points, mult + t_mult}
                end)
            end
          else
            card_map
          end
      end

    card_map
    |> Enum.map(fn {_, {_, _, cards}} -> cards end)
    |> Enum.sum()
  end
end
