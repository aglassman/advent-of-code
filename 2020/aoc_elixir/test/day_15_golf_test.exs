defmodule Day15GolfTest do
  use ExUnit.Case

  @moduledoc """
  This solution is the same as the recursive solution, but minimized
  """

  import Map, only: [put: 3, get: 2]

  @example [0, 3, 6]

  @input [0, 5, 4, 1, 10, 14, 7]

  test "example - part 1" do
    assert 436 = p(@example, 2020)
  end

  test "day 15 - part 1" do
    assert 203 = p(@input, 2020)
  end

  test "day 15 - part 2" do
    assert 9_007_186 = p(@input, 30_000_000)
  end

  def p([], m, s, t, l), do: p(s, t, m, l, nil)
  def p([hd | tl], m, s \\ %{}, t \\ 1, l \\ nil), do: p(tl, m, put(s, hd, t), t + 1, hd)
  def p(%{}, t, m, l, _) when t - 1 == m, do: l
  def p(%{} = s, t, m, l, h), do: p(put(s, s(h, t), t), t + 1, m, s(h, t), get(s, s(h, t)))
  def s(nil, _), do: 0
  def s(x, t), do: t - 1 - x
end
