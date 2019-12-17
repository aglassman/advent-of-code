defmodule AocDay5ElixirTest do
  use ExUnit.Case
  doctest IntComp


  test "test instruction parser" do
    assert %IntComp.Op{
              opcode: :multiply,
              params: [
                { 4, :position },
                { 3, :immediate },
                { 4, :position } ]
           } == IntComp.Op.instruction_to_op([1002,4,3,4])
  end

  test "Day 5: Part 1" do
    File.read!('input/5.txt') |> String.split(",") |> Enum.map(&Integer.parse/1) |> Enum.map(&(elem(&1,0))) |> IntComp.run_program()
  end

end