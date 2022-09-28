defmodule Day04Test do
  use ExUnit.Case

  @range 134_564..585_159

  test "part 1" do
    valid_passwords =
      @range
      |> Stream.map(&to_string/1)
      |> Stream.map(&String.graphemes/1)
      |> Stream.filter(&always_increasing?/1)
      |> Enum.filter(&at_least_two?/1)

    assert 1929 == length(valid_passwords)
  end

  test "part 2" do
    valid_passwords =
      @range
      |> Stream.map(&to_string/1)
      |> Stream.map(&String.graphemes/1)
      |> Stream.filter(&always_increasing?/1)
      |> Enum.filter(&exactly_two?/1)

    assert 1306 == length(valid_passwords)
  end

  def always_increasing?([a, b, c, d, e, f]) do
    a <= b and b <= c and c <= d and d <= e and e <= f
  end

  def at_least_two?(candidate) do
    case candidate do
      [b,b,_,_,_,_] -> true
      [_,b,b,_,_,_] -> true
      [_,_,b,b,_,_] -> true
      [_,_,_,b,b,_] -> true
      [_,_,_,_,b,b] -> true
      _ ->
        false
    end
  end

  def exactly_two?(candidate) do
    case candidate do
      [b,b,c,_,_,_] when b != c -> true
      [a,b,b,c,_,_] when a != b and b != c -> true
      [_,a,b,b,c,_] when a != b and b != c -> true
      [_,_,a,b,b,c] when a != b and b != c -> true
      [_,_,_,a,b,b] when a != b -> true
      _ ->
        false
    end
  end
end
