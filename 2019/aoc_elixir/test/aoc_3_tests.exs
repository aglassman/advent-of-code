defmodule AocDay3ElixirTest do
  use ExUnit.Case
  doctest AocElixir3

  test "examples" do
    assert AocElixir3.grid([
      ["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
      ["U62","R66","U55","R34","D71","R55","D58","R83"]
    ]) |> AocElixir3.closest() == 159

    assert AocElixir3.grid([
      ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
      ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]
    ]) |> AocElixir3.closest() == 159

  end

end