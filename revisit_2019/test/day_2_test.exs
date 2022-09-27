defmodule Day02Test do
  use ExUnit.Case

  import IntCodeComputer

  test "part 1" do
    output =
      input()
      |> String.split(",")
      |> then(&new/1)
      |> then(&Map.put(&1, 1, 12))
      |> then(&Map.put(&1, 2, 2))
      |> then(&execute(&1))
      |> then(&Map.get(&1, 0))

    assert 4_023_471 == output
  end

  test "part 2" do
    for noun <- 0..99, verb <- 0..99 do
      output =
        input()
        |> String.split(",")
        |> then(&new/1)
        |> then(&Map.put(&1, 1, noun))
        |> then(&Map.put(&1, 2, verb))
        |> then(&execute(&1))
        |> then(&Map.get(&1, 0))

      if 19_690_720 == output do
        raise to_string(100 * noun + verb)
      end
    end
  rescue
    error ->
      assert "8051" == error.message
  end

  def input_test(), do: "1,9,10,3,2,3,11,0,99,30,40,50"

  def input(),
    do:
      "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,6,19,1,5,19,23,1,23,6,27,1,5,27,31,1,31,6,35,1,9,35,39,2,10,39,43,1,43,6,47,2,6,47,51,1,5,51,55,1,55,13,59,1,59,10,63,2,10,63,67,1,9,67,71,2,6,71,75,1,5,75,79,2,79,13,83,1,83,5,87,1,87,9,91,1,5,91,95,1,5,95,99,1,99,13,103,1,10,103,107,1,107,9,111,1,6,111,115,2,115,13,119,1,10,119,123,2,123,6,127,1,5,127,131,1,5,131,135,1,135,6,139,2,139,10,143,2,143,9,147,1,147,6,151,1,151,13,155,2,155,9,159,1,6,159,163,1,5,163,167,1,5,167,171,1,10,171,175,1,13,175,179,1,179,2,183,1,9,183,0,99,2,14,0,0"
end
