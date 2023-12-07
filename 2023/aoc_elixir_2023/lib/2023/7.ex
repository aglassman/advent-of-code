import AOC

aoc 2023, 7 do
  @moduledoc """
  https://adventofcode.com/2023/day/7
  """

  @strength ~w(2 3 4 5 6 7 8 9 T J Q K A) |> Enum.with_index(2) |> Map.new()
  @strength_jacks_wild ~w(J 2 3 4 5 6 7 8 9 T Q K A) |> Enum.with_index(2) |> Map.new()

  def parse(input, strength_map \\ @strength) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [str_hand, bid] ->
      hand = parse_hand(str_hand, strength_map)
      sorted = Enum.sort(hand, :desc)
      {str_hand, hand, sorted, String.to_integer(bid)}
    end)
  end

  def parse_hand(hand, strength_map) do
    hand
    |> String.graphemes()
    |> Enum.map(&Map.get(strength_map, &1))
  end

  def sorted_hand_rank([2, 2, 2, 2, 2], :jacks_wild), do: 6

  def sorted_hand_rank(hand, :jacks_wild) do
    if 2 in hand do
      {wild_value, count} = hand
      |> Enum.reject(fn card -> card == 2 end)
      |> Enum.frequencies()
      |> Enum.max_by(fn {card, count} -> {count, card} end)

      wild_hand = hand
      |> Enum.map(fn card ->
        if card == 2 do
          wild_value
        else
          card
        end
      end)
      |> Enum.sort(:desc)

      case sorted_hand_rank(wild_hand, nil) do
        0 -> 1
        x -> x
      end

    else
      sorted_hand_rank(hand, nil)
    end
  end

  def sorted_hand_rank(hand, _) do
    case hand do
      # five of a kind
      [a, a, a, a, a] -> 6

      # four of a kind
      [_, a, a, a, a] -> 5
      [a, a, a, a, _] -> 5

      # full house
      [a, a, a, b, b] -> 4
      [a, a, b, b, b] -> 4

      # three of a kind
      [a, a, a, b, c] -> 3
      [a, b, b, b, c] -> 3
      [a, b, c, c, c] -> 3

      # two pair
      [a, a, b, b, _] -> 2
      [a, a, _, b, b] -> 2
      [_, a, a, b, b] -> 2

      # one pair
      [a, a, _, _, _] -> 1
      [_, a, a, _, _] -> 1
      [_, _, a, a, _] -> 1
      [_, _, _, a, a] -> 1

      # high card
      _ -> 0
    end
  end

  def compare_tie([a | ta], [a | tb]), do: compare_tie(ta, tb)
  def compare_tie([a | _], [b | _]), do: a >= b

  def compare_hands({raw_a, hand_a, sorted_hand_a, _} = a, {raw_b, hand_b, sorted_hand_b, _} = b, game \\ nil) do
    rank_a = sorted_hand_rank(sorted_hand_a, game)
    rank_b = sorted_hand_rank(sorted_hand_b, game)

    cond do
      rank_a > rank_b ->
        true
      rank_a == rank_b ->
        tb = compare_tie(hand_a, hand_b)
        IO.inspect([raw_a, raw_b, a, b, rank_a, rank_b, tb], charlists: :as_string)
        tb

      true -> false
    end
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    input
    |> parse()
    |> Enum.sort(&compare_hands/2)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, _, bid}, rank}, total -> total + (rank * bid) end)
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    input
    |> parse(@strength_jacks_wild)
    |> Enum.sort(&compare_hands(&1, &2, :jacks_wild))
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, _, bid}, rank}, total -> total + (rank * bid) end)
  end
end
