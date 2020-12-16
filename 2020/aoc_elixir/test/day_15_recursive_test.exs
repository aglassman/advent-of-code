defmodule Day15GolfTest do
  use ExUnit.Case

  @moduledoc """
  This is a fully recursive solution.
  """

  import Map, only: [put: 3, get: 2]

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

  # Done with init
  def play([], max, state, turn, last) do
    play(state, turn, max, last, nil)
  end

  # init with input array
  def play([hd | tl], max, state \\ %{}, turn \\ 1, last \\ nil) do
    play(tl, max, put(state, hd, turn), turn + 1, hd)
  end

  # stop condition
  def play(%{}, turn, max, last, history) when turn - 1  == max, do: last

  # this is the main game
  def play(%{} = state, turn, max, last, history)  do
    say = say(history, turn)

    state
    |> put(say, turn)
    |> play(turn + 1, max, say, get(state, say))
  end

  # determine what to say
  def say(nil, _), do: 0
  def say(x, turn), do: turn - 1 - x

end