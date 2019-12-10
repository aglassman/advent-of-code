defmodule AocDay1ElixirTest do
  use ExUnit.Case
  doctest AocElixir1

  test "fuel weight calculation" do
    assert AocElixir1.fuel_weight(12) == 2
    assert AocElixir1.fuel_weight(14) == 2
    assert AocElixir1.fuel_weight(1969) == 654
    assert AocElixir1.fuel_weight(100756) == 33583
  end

  test "day 1: part 1" do
    AocElixir1.getModuleWeights('input/1.txt')
    |> Stream.map(&AocElixir1.fuel_weight/1)
    |> Enum.sum
    |> IO.inspect
  end

  test "day 1: part 2" do
    AocElixir1.getModuleWeights('input/1.txt')
    |> Stream.map(&AocElixir1.fuel_weight_recursive/1)
    |> Enum.sum
    |> IO.inspect
  end

end
