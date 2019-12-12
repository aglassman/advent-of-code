defmodule AocDay3ElixirTest do
  use ExUnit.Case
  doctest AocElixir3

  test "examples" do
    assert AocElixir3.createGrid([
      ["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
      ["U62","R66","U55","R34","D71","R55","D58","R83"]
    ]) |> AocElixir3.closest() == 159

    assert AocElixir3.grid([
      ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
      ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]
    ]) |> AocElixir3.closest() == 159

  end

  test "expand wire instructions" do
    AocElixir3.expandWireInstructions(["U4","R3","U3","R2","D4","L3"] ,2) |> IO.inspect()
  end

  test "parse direction and distance" do
    assert "R33" |> AocElixir3.parseWireInstruction == %{ direction: :x, distance: 33 }
    assert "L15" |> AocElixir3.parseWireInstruction == %{ direction: :x, distance: -15 }
    assert "U33" |> AocElixir3.parseWireInstruction == %{ direction: :y, distance: 33 }
    assert "D14" |> AocElixir3.parseWireInstruction == %{ direction: :y, distance: -14 }
  end

  test "manhattan distance" do
    assert AocElixir3.manhattanDistance(%{ x: 1, y: 1 }, %{ x: 1, y: 1 }) == 0
    assert AocElixir3.manhattanDistance(%{ x: 0, y: 0 }, %{ x: 0, y: 1 }) == 1
    assert AocElixir3.manhattanDistance(%{ x: 0, y: 0 }, %{ x: 1, y: 1 }) == 2
    assert AocElixir3.manhattanDistance(%{ x: 1, y: 1 }, %{ x: 0, y: 0 }) == 2
    assert AocElixir3.manhattanDistance(%{ x: -1, y: 0 }, %{ x: 1, y: 1 }) == 3
    assert AocElixir3.manhattanDistance(%{ x: 1, y: 1 }, %{ x: -1, y: 0 }) == 3
    assert AocElixir3.manhattanDistance(%{ x: -1, y: -1 }, %{ x: 1, y: 1 }) == 4
    assert AocElixir3.manhattanDistance(%{ x: 1, y: 1 }, %{ x: -1, y: -1 }) == 4
  end

  test "intersections" do

    grid =   [
      %{ x: 0, y: 0, wire: 0 },
      %{ x: 0, y: 1, wire: 0 },
      %{ x: 0, y: 2, wire: 0 },

      %{ x: 0, y: 0, wire: 1 },
      %{ x: 1, y: 0, wire: 1 },
      %{ x: 1, y: 1, wire: 1 },
      %{ x: 1, y: 2, wire: 1 },
      %{ x: 0, y: 2, wire: 1 },
      %{ x: 0, y: 3, wire: 1 }
    ]

    intersections = grid |> AocElixir3.intersections

    assert intersections |> Map.get(%{ x: 0, y: 0 })  == [1,0]
    assert intersections |> Map.get(%{ x: 0, y: 2 })  == [1,0]

  end

  test "createGrid" do
    wires = [
      ["U1", "U1"],
      ["L1", "U2", "L1", "U1"]
    ]

    grid = wires |> AocElixir3.createGrid

    assert grid == [
             %{ x: 0, y: 0, wire: 0 },
             %{ x: 0, y: 1, wire: 0 },
             %{ x: 0, y: 2, wire: 0 },

             %{ x: 0, y: 0, wire: 1 },
             %{ x: 1, y: 0, wire: 1 },
             %{ x: 1, y: 1, wire: 1 },
             %{ x: 1, y: 2, wire: 1 },
             %{ x: 0, y: 2, wire: 1 },
             %{ x: 0, y: 3, wire: 1 }
           ]

  end

end