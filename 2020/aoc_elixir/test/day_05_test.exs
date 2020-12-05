defmodule Day05Test do
  use ExUnit.Case

  import String, only: [replace: 3]

  test "example - part 1" do
    assert {70, 7, 567} = find_seat("BFFFBBFRRR")
    assert {14, 7, 119} = find_seat("FFFBBBFRRR")
    assert {102, 4, 820} = find_seat("BBFFBBFRLL")
  end

  test "day 5 - part 1" do
    assert 818 ==
             File.read!("input/5.txt")
             |> String.split("\n")
             |> Stream.map(&find_seat/1)
             |> Enum.max_by(fn {row, column, seat_id} -> seat_id end)
             |> elem(2)
  end

  test "day 5 - part 2" do
    assert 559 ==
             File.read!("input/5.txt")
             |> String.split("\n")
             |> Stream.map(&find_seat/1)
             |> Enum.sort_by(fn {_, _, seat_id} -> seat_id end)
             |> Enum.reduce_while(0, fn {_, _, seat_id}, last_seat_id ->
               if last_seat_id == 0 || seat_id - last_seat_id == 1 do
                 {:cont, seat_id}
               else
                 {:halt, seat_id - 1}
               end
             end)
  end

  def find_seat(<<bsp_row::binary-size(7), bsp_column::binary-size(3)>>) do
    {row, column} = {to_int(bsp_row), to_int(bsp_column)}
    {row, column, row * 8 + column}
  end

  def to_int(string),
    do:
      string
      |> replace("B", "1")
      |> replace("F", "0")
      |> replace("L", "0")
      |> replace("R", "1")
      |> Integer.parse(2)
      |> elem(0)
end
