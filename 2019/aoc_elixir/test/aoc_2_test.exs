defmodule AocDay2ElixirTest do
  use ExUnit.Case
  doctest IntComp

  test "program parser" do
    IO.inspect(IntComp.run_program([1,0,0,0,99]))
  end

  test "examples" do
    assert IntComp.run_program([1,0,0,0,99],0) == [2,0,0,0,99]
    assert IntComp.run_program([2,3,0,3,99],0) == [2,3,0,6,99]
    assert IntComp.run_program([2,4,4,5,99,0],0) == [2,4,4,5,99,9801]
    assert IntComp.run_program([1,1,1,4,99,5,6,0,99],0) == [30,1,1,4,2,5,6,0,99]
  end

  test "Day 2: Part 1" do
    File.read!('input/2.txt')
    |> String.split(",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1,0)))
    |> List.replace_at(1,12)
    |> List.replace_at(2,2)
    |> IntComp.run_program()
    |> List.first()
    |> IO.inspect
  end

  test "Day 2: Part 2" do
    params = for noun <- 0..99, verb <- 0..99, do: %{noun: noun, verb: verb}

    program = File.read!('input/2.txt')
    |> String.split(",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1,0)))

    params
    |> Enum.map(&(
        %{
          input: &1,
          output: IntComp.output_for_input(program, &1)
        }
      ))
    |> Enum.filter(&(&1.output == 19690720))
    |> Enum.map(&(100 * &1.input.noun + &1.input.verb))
    |> Enum.map(&IO.inspect/1)

  end

  test "comprehension" do
    for noun <- 0..99, verb <- 0..99, do: {noun, verb}
    |> IO.inspect
  end
end
