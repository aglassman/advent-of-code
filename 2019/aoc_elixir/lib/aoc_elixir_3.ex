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
      |> Enum.map(&(
        current_position
        |> Map.update(wire_instruction.direction, :oops, fn pos -> pos + &1 end)
        |> Map.put(:segment, wire_instruction.segment )))

      wire_segment ++ expanded_wire
    end


    wire_instructions
    |> Enum.with_index()
    |> Enum.map(&AocElixir3.parseWireInstruction/1)
    #|> IO.inspect()
    |> Enum.reduce(expanded_wire, expand_wire)
    #|> IO.inspect()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(&( &1 |> elem(0) |> Map.put(:length, &1 |> elem(1) ) ))
  end

  def parseWireInstruction({instructionString, index }) do
    {direction, distance} = instructionString |> String.split_at(1)

    distance = Integer.parse(distance) |> elem(0)

    axis = case direction do
      "U" -> {:y, 1}
      "D" -> {:y, -1}
      "R" -> {:x, 1}
      "L" -> {:x, -1}
    end

    %{direction: axis |> elem(0), distance: (axis |> elem(1)) * distance, segment: index}

  end

  @doc """
  Returns all wire intersections mapped by location.
  %{
    %{ x: 2, y: 5 } => [1,4] },
    %{ x: 5, y: 9 } => [2,8,9] },
    %{ x: 1, y: 1 } => [1,4] }
  }

  if detailed == true, full wire segment and length will be included in intersection list.
    %{
      %{ x: 2, y: 5 } => [
        %{wire: 1, segment: 0, length: 3, x: 0, y: 1},
        %{wire: 2, segment: 4, length: 2, x: 0, y: 1}
      ]
    },
      ...
    }

  """
  def intersections(grid, detailed \\ false) do
    # Build up a map, where the key is the location, and the value is a list of wires that occupy
    # that location.

    segment_accumulator = fn wire_section, acc ->

      location = wire_section |> Map.take([:x, :y])

      intersection_list = acc
      |> Map.get(location, [])
      |> List.insert_at(0, wire_section)

      acc |> Map.put(location, intersection_list)

    end

    isIntersection = fn segment ->
      wire_count = segment
                   |> elem(1)
                   |> Enum.map(&(Map.take(&1,[:wire])))
                   |> Enum.uniq()
                   |> Enum.count()
      wire_count > 1
    end

    wire_map = case detailed do
      true ->  fn wire_segment -> wire_segment end
      false -> fn wire_segment -> Map.get(wire_segment, :wire) end
    end

    intersection_accumulator = fn intersection, acc ->
      location = intersection |> elem(0)
      wire = intersection
             |> elem(1)
             |> Enum.map(wire_map)
             |> IO.inspect

      Map.put(acc, location, wire)
    end

    grid
    |> Enum.reduce(%{ %{x: 0, y: 0} => [] }, segment_accumulator)
    |> Enum.filter(isIntersection)
    |> Enum.reduce(%{}, intersection_accumulator)

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

  def lowestCombinedSegmentLength(intersections) do
    intersections

  end

  @doc """
  Find manhattan distance from given point.
  """
  def manhattanDistance(point_a, point_b) do
    abs(point_b.x - point_a.x) + abs(point_b.y - point_a.y)
  end

end