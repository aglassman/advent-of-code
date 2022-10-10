defmodule Day11Test do
  use ExUnit.Case

  import IntCodeComputer

  test "part 1" do
    program = new(input())
    program = %{program | name: "paint_program", on_halt: self()}
    runtime_pid = spawn(fn -> wait_for_link(program) end)

    send(runtime_pid, {:link, program, self()})


    state = draw(runtime_pid)

    assert 2172 == map_size(state) - 2
  end

  test "part 2" do
    program = new(input())
    program = %{program | name: "paint_program", on_halt: self()}
    runtime_pid = spawn(fn -> wait_for_link(program) end)

    send(runtime_pid, {:link, program, self()})


    state = draw(runtime_pid, %{:position => {0, 0}, :direction =>  0, {0, 0} => [1]})

    positions = Map.drop(state, [:position, :direction])
    {min_x, max_x} = Enum.map(positions, fn {{x, _}, _} -> x end) |> Enum.min_max() |> IO.inspect()
    {min_y, max_y} = Enum.map(positions, fn {{_, y}, _} -> y end) |> Enum.min_max() |> IO.inspect()


    raster = for x <- min_x..max_x, y <- min_y..max_y do
      [color | _] = state[{x,y}] || [0]
      if color == 1 do
        "0"
      else
        " "
      end
    end

    for line <- Enum.chunk_every(raster, 6, 6) do
      IO.puts(line)
    end

    assert raster = """
            0
           0
           0    0
            00000

           000000
           0  0 0
           0  0 0
           0    0

           000000
           0
           0
           0

           000000
           0  0 0
           0  0 0
           0    0

           000000
              0 0
              0 0
                0

            0000
           0    0
           0 0  0
           000 0

           000000
              0
              0
           000000

           000000
             0  0
             0  0
              00
"""  |> String.trim() |> String.replace("\n", "") |> String.graphemes()

  end

  @directions [{0, 1},{1, 0},{0, -1},{-1, 0}]

  def draw(runtime_pid, state \\ %{position: {0, 0}, direction: 0}, buffer \\ [])

  def draw(runtime_pid, state, [direction, color] = buffer) do
#    IO.inspect(direction, label: :direction)
#    IO.inspect(color, label: :color)

    state = state
            |> paint(color)
            |> direction(direction)
            |> next_position()
#            |> IO.inspect()

    draw(runtime_pid, state, [])
  end

  def draw(runtime_pid, state, buffer) do
    if match?([], buffer) do
      check_camera(state, runtime_pid)
    end

    receive do
      {:halt, _} ->
        state

      output ->
#        IO.inspect([output | buffer], label: :build_buffer)
        draw(runtime_pid, state, [output | buffer])

    end
  end

  def check_camera(state, runtime_pid) do
    [current_color | _] = Map.get(state, state.position, [0])
#    IO.inspect(current_color, label: :check_camera)
    send(runtime_pid, current_color)
  end

  def paint(state, color) do
    Map.update(state, state.position, [color], fn existing -> [color | existing] end)
  end

  def direction(%{direction: r} = state, 0), do: %{state | direction: r - 1}
  def direction(%{direction: r} = state, 1), do: %{state | direction: r + 1}

  def next_position(%{position: {x1, y1}, direction: r} = state) do
    {x2, y2} = Enum.at(@directions, rem(r, 4))
    %{state | position: {x1 + x2, y1 + y2}}
  end

  def input(), do: "3,8,1005,8,342,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1002,8,1,29,2,1006,19,10,1,1005,19,10,2,1102,11,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,1001,8,0,62,2,1009,15,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,1002,8,1,88,2,1101,6,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,114,1,105,8,10,1,1102,18,10,2,6,5,10,1,2,15,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,1001,8,0,153,1,105,15,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,178,1,1006,15,10,1006,0,96,1006,0,35,1,104,7,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,214,1006,0,44,2,1105,17,10,1,1107,19,10,1,4,16,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,102,1,8,252,1006,0,6,1,1001,20,10,1006,0,45,2,1109,5,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,287,2,101,20,10,2,1006,18,10,1,1009,9,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,321,101,1,9,9,1007,9,1031,10,1005,10,15,99,109,664,104,0,104,1,21102,48210117528,1,1,21102,1,359,0,1105,1,463,21102,932700763028,1,1,21102,370,1,0,1105,1,463,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,1,179557207079,1,21102,417,1,0,1105,1,463,21102,1,28994202816,1,21101,0,428,0,1105,1,463,3,10,104,0,104,0,3,10,104,0,104,0,21101,0,709580710756,1,21102,1,451,0,1106,0,463,21102,825016201984,1,1,21101,462,0,0,1106,0,463,99,109,2,21201,-1,0,1,21102,40,1,2,21101,0,494,3,21102,1,484,0,1105,1,527,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,489,490,505,4,0,1001,489,1,489,108,4,489,10,1006,10,521,1101,0,0,489,109,-2,2105,1,0,0,109,4,1201,-1,0,526,1207,-3,0,10,1006,10,544,21102,1,0,-3,21202,-3,1,1,22102,1,-2,2,21102,1,1,3,21102,563,1,0,1105,1,568,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,591,2207,-4,-2,10,1006,10,591,21202,-4,1,-4,1105,1,659,22102,1,-4,1,21201,-3,-1,2,21202,-2,2,3,21102,610,1,0,1106,0,568,21201,1,0,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,629,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,651,21202,-1,1,1,21102,1,651,0,106,0,526,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0"

end