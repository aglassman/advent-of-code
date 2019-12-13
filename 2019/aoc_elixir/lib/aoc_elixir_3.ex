defmodule AocElixir3 do
  @moduledoc """
  Documentation for AocElixir3.
  """

  @doc """

  A grid is a sparse representation of locations a wire has passed through.
  All wires start at the origin %{ x: 0, y: 0, wire: 0}

  [
    %{ x: 0, y: 0, wire: 0},
    %{ x: 0, y: 1, wire: 0},
    %{ x: 0, y: 2, wire: 0},

    %{ x: 0, y: 0, wire: 1},
    %{ x: 1, y: 0, wire: 1},
    %{ x: 1, y: 1, wire: 1}
  ]

  """
  def createGrid(wires) do
    wires
    |> Enum.with_index()
    |> Enum.flat_map(&(expandWireInstructions(&1 |> elem(0), &1 |> elem(1))))
  end

  @doc """
  This will turn instructions into a list of coordinates the wire actually visited.
  input = ["R23", "D5", ... ]
  """
  def expandWireInstructions(wire_instructions, wire_id) do

    expanded_wire = [%{x: 0, y: 0, wire: wire_id}]

    expand_wire = fn wire_instruction, expanded_wire ->

      current_position = expanded_wire |> List.first()

      start = cond do
        wire_instruction.distance < 0 -> -1
        wire_instruction.distance > 0 -> 1
        wire_instruction.distance == 0 -> 0
      end

      comprehension = for i <- start..wire_instruction.distance, do: i

      comprehension = Enum.reverse(comprehension)

      wire_segment = comprehension
      |> Enum.map(&( current_position |> Map.update(wire_instruction.direction, :oops, fn pos -> pos + &1 end) ))

      wire_segment ++ expanded_wire #|> IO.inspect()
    end


    wire_instructions
    |> Enum.map(&AocElixir3.parseWireInstruction/1)
    #|> IO.inspect()
    |> Enum.reduce(expanded_wire, expand_wire)
    #|> IO.inspect()
    |> Enum.reverse()
  end

  def parseWireInstruction(instructionString) do
    {direction, distance} = instructionString |> String.split_at(1)

    distance = Integer.parse(distance) |> elem(0)

    axis = case direction do
      "U" -> {:y, 1}
      "D" -> {:y, -1}
      "R" -> {:x, 1}
      "L" -> {:x, -1}
    end

    %{direction: axis |> elem(0), distance: (axis |> elem(1)) * distance}

  end

  @doc """
  Returns all wire intersections mapped by location.
  %{
    %{ x: 2, y: 5 } => [1,4] },
    %{ x: 5, y: 9 } => [2,8,9] },
    %{ x: 1, y: 1 } => [1,4] }
  }
  """
  def intersections(grid) do
    # Build up a map, where the key is the location, and the value is a list of wires that occupy
    # that location.

    segment_accumulator = fn wire_section, acc->

      location = wire_section |> Map.take([:x, :y])

      intersection_list = acc
      |> Map.get(location, [])
      |> List.insert_at(0, wire_section.wire)

      acc |> Map.put(location, intersection_list)

    end

    isIntersection = fn segment ->
      wire_count = segment |> elem(1) |> Enum.count()
      wire_count > 1
    end

    grid
    |> Enum.reduce(%{ %{x: 0, y: 0} => [] }, segment_accumulator)
    |> Enum.filter(isIntersection)
    |> Enum.reduce(%{}, &( Map.put(&2, &1 |> elem(0), &1 |> elem(1))))

  end

  @doc """
  Determine closest intersection to provided point. Default is origin %{ x: 0, y: 0}
  Retuns a tuple of location, and distance
  { %{x: 3, y: 3}, 6 }
  """
  def closestIntersectionTo(intersections, point \\ %{ x: 0, y: 0}) do
    intersections
    |> Map.keys()
    |> Enum.filter(&( point != &1 ))
    |> Enum.map(&( { &1, manhattanDistance(&1, point) } ))
    |> Enum.min_by(&( &1 |> elem(1)  ))
  end

  @doc """
  Find manhattan distance from given point.
  """
  def manhattanDistance(point_a, point_b) do
    abs(point_b.x - point_a.x) + abs(point_b.y - point_a.y)
  end

end