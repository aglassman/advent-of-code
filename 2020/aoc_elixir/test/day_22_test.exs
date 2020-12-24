defmodule Day22Test do
  use ExUnit.Case

  @example """
  Player 1:
  9
  2
  6
  3
  1

  Player 2:
  5
  8
  4
  7
  10
  """

  @example_2 """
  Player 1:
  43
  19

  Player 2:
  2
  29
  14
  """

  test "example - part 1" do
    assert 306 ==
             game(@example)
             |> play()
             |> score()
  end

  test "day 22 - part 1" do
    assert 33010 ==
             "input/22.txt"
             |> File.read!()
             |> game()
             |> play()
             |> score()
  end

  test "example - part 2" do
    assert 291 ==
             @example
             |> game()
             |> play_recursive()
             |> score()
  end

  test "day 22 - part 2" do
    assert 0 ==
             "input/22.txt"
             |> File.read!()
             |> game()
             |> play_recursive()
             |> score()
  end

  def game(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(fn player_input ->
      [player_id, cards] = String.split(player_input, ":\n", trim: true)

      cards =
        cards
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)

      {player_id, cards}
    end)
  end

  def play_recursive(game, history \\ %{game: 1, round: 1})

  # p1 wins game
  def play_recursive([{p1, c1}, {p2, c2}] = state, %{game: g, round: r} = history)
      when is_map_key(history, state) do
    p1
  end

  # recurse!
  def play_recursive([{p1, [h1 | tl1]}, {p2, [h2 | tl2]}] = state, %{game: g, round: r} = history)
      when length(tl1) >= h1 and length(tl2) >= h2 do
    if p1 == play_recursive([{p1, tl1}, {p2, tl2}], %{game: g + 1, round: 1}) do
      IO.inspect(["game: #{g} round: #{r}", :b])
      [{p1, tl1 ++ [h1, h2]}, {p2, tl2}]
    else
      IO.inspect(["game: #{g} round: #{r}", :b])
      [{p1, tl1}, {p2, tl2 ++ [h2, h1]}]
    end
    |> play_recursive(history |> Map.put(state, true) |> Map.put(:round, r + 1))
  end

  def play_recursive(
        [{p1, [h1 | tl1] = c1}, {p2, [h2 | tl2] = c2}],
        %{game: 1, round: r} = history
      )
      when length(tl1) == 0 or length(tl2) == 0 do
    # IO.inspect(["end! game: #{1} round: #{r}", :c])
    if h1 > h2 do
      [{p1, tl1 ++ [h1, h2]}, {p2, tl2}]
    else
      [{p1, tl1}, {p2, tl2 ++ [h2, h1]}]
    end
  end

  def play_recursive([{p1, [h1 | tl1]}, {p2, [h2 | tl2]}], %{game: g, round: r} = history)
      when length(tl1) == 0 or length(tl2) == 0 do
    # IO.inspect(["game: #{g} round: #{r}", :c])
    if h1 > h2 do
      p1
    else
      p2
    end
  end

  def play_recursive([{p1, [h1 | tl1]}, {p2, [h2 | tl2]}] = state, %{game: g, round: r} = history) do
    # IO.inspect(["game: #{g} round: #{r}", :d_in, state])
    outcome =
      if h1 > h2 do
        [{p1, tl1 ++ [h1, h2]}, {p2, tl2}]
      else
        [{p1, tl1}, {p2, tl2 ++ [h2, h1]}]
      end

    # IO.inspect(["game: #{g} round: #{r}", :d_out, outcome])
    play_recursive(outcome, history |> Map.put(state, true) |> Map.put(:round, r + 1))
  end

  def play([{p1, c1}, {p2, c2}] = game) when length(c1) == 0 or length(c2) == 0 do
    game
  end

  def play([{p1, [h1 | tl1]}, {p2, [h2 | tl2]}]) do
    if h1 > h2 do
      [{p1, tl1 ++ [h1, h2]}, {p2, tl2}]
    else
      [{p1, tl1}, {p2, tl2 ++ [h2, h1]}]
    end
    |> play()
  end

  def score([{_, c1}, {_, c2}]) do
    (c1 ++ c2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> IO.inspect()
    |> Enum.reduce(0, fn {val, i}, acc ->
      acc + val * (i + 1)
    end)
  end
end
