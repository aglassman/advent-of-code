defmodule Day15Test do
  use ExUnit.Case

  @example [0,3,6]

  @input [0,5,4,1,10,14,7]

  test "example - part 1" do
    assert 436 = play(@example, 2020)
  end

  test "day 15 - part 1" do
    assert 203 = play(@input, 2020)
  end

  test "day 15 - part 2" do
    assert 9007186 = play(@input, 30000000)
  end

  def play(_, last, turn, stop_at) when turn - 1 == stop_at, do: last

  def play(state, last, turn, stop_at) do
    say = case Map.get(state, last) do
      nil -> 0
      [x] -> 0
      [a | [b | _]] -> a - b
    end

    play(
      Map.update(state, say, [turn], fn list -> [turn | list]  end),
      say,
      turn + 1,
      stop_at)
  end

  def play(start, stop_at) when is_list(start) do
    start
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> {x, [i + 1]} end)
    |> Map.new()
    |> play(Enum.at(start, -1), Enum.count(start) + 1, stop_at)
  end



end