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

  def total_winnings(hands) do
    hands
    |> Enum.sort_by(fn {order, _} -> order end)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, bid}, rank}, total -> total + (rank * bid) end)
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    input
    |> parse()
    |> Enum.map(fn {_, hand, sorted, bid} ->
      sorted_freq = hand |> Enum.frequencies() |> Map.values() |> Enum.sort(:desc)
      {{sorted_freq, hand}, bid}
    end)
    |> total_winnings()
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    input
    |> parse(@strength_jacks_wild)
    |> Enum.map(fn {_, hand, sorted, bid} ->
      freq = case Enum.frequencies(hand) do
        %{2 => 5} = freq ->
          freq

        %{2 => wild_count} = freq ->
          sans_2 = freq |> Map.delete(2)
          {max_key, max_val} = Enum.max_by(sans_2, fn {k, v} -> {v, k} end)
          Map.put(sans_2, max_key, max_val + wild_count)

        freq ->
          freq
      end
      sorted_freq = freq |> Map.values() |> Enum.sort(:desc)
      {{sorted_freq, hand}, bid}
    end)
    |> total_winnings()
  end
end
