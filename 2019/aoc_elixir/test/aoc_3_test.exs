defmodule AocDay3ElixirTest do
  use ExUnit.Case
  doctest AocElixir3

  test "Day 3: Part 1" do
    File.stream!('input/3.txt')
    |> Enum.with_index
    |> Enum.map(&(String.split(&1 |> elem(0), ",")))
    |> AocElixir3.createGrid()
    |> AocElixir3.intersections()
    |> AocElixir3.closestIntersectionTo()
    |> IO.inspect()
    |> elem(1)
    |> IO.inspect()

  end

  test "example 1" do

    wires = [
      ["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
      ["U62","R66","U55","R34","D71","R55","D58","R83"]
    ]

    closest_intersection = wires
    |> AocElixir3.createGrid()
    |> AocElixir3.intersections()
    |> AocElixir3.closestIntersectionTo()
    |> IO.inspect()
    |> elem(1)

    assert 159 == closest_intersection
  end

  test "example 2" do

    wires = [
      ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"],
      ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]
    ]

    closest_intersection = wires
    |> AocElixir3.createGrid()
    |> AocElixir3.intersections()
    |> AocElixir3.closestIntersectionTo()
    |> IO.inspect()
    |> elem(1)

    assert 135 == closest_intersection
  end

  test "expand wire instructions" do
    wire_path = AocElixir3.expandWireInstructions(["U4","R3","U3","R2","D4","L3"] ,2)

    assert [
             %{wire: 2, x: 0, y: 0},

             %{wire: 2, x: 0, y: 1},
             %{wire: 2, x: 0, y: 2},
             %{wire: 2, x: 0, y: 3},
             %{wire: 2, x: 0, y: 4},

             %{wire: 2, x: 1, y: 4},
             %{wire: 2, x: 2, y: 4},
             %{wire: 2, x: 3, y: 4},

             %{wire: 2, x: 3, y: 5},
             %{wire: 2, x: 3, y: 6},
             %{wire: 2, x: 3, y: 7},

             %{wire: 2, x: 4, y: 7},
             %{wire: 2, x: 5, y: 7},

             %{wire: 2, x: 5, y: 6},
             %{wire: 2, x: 5, y: 5},
             %{wire: 2, x: 5, y: 4},
             %{wire: 2, x: 5, y: 3},

             %{wire: 2, x: 4, y: 3},
             %{wire: 2, x: 3, y: 3},
             %{wire: 2, x: 2, y: 3}
           ] == wire_path
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

    assert 2 == intersections |> Enum.count()
    assert [1,0] == intersections |> Map.get(%{ x: 0, y: 0 })
    assert [1,0] == intersections |> Map.get(%{ x: 0, y: 2 })

  end

  test "createGrid" do
    wires = [
      ["U1", "U1"],
      ["R1", "U2", "L1", "D1"]
    ]

    grid = wires |> AocElixir3.createGrid

    assert [
             %{ x: 0, y: 0, wire: 0 },
             %{ x: 0, y: 1, wire: 0 },
             %{ x: 0, y: 2, wire: 0 },

             %{ x: 0, y: 0, wire: 1 },
             %{ x: 1, y: 0, wire: 1 },
             %{ x: 1, y: 1, wire: 1 },
             %{ x: 1, y: 2, wire: 1 },
             %{ x: 0, y: 2, wire: 1 },
             %{ x: 0, y: 1, wire: 1 }
           ] == grid

  end

end