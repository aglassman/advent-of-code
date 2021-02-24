defmodule Day23Test do
  use ExUnit.Case

  @example [3, 8, 9, 1, 2, 5, 4, 6, 7]

  @my_input [7, 9, 2, 8, 4, 5, 1, 3, 6]

  test "example - part 1 - 10 moves" do
    assert "92658374" ==
             @example
             |> play(10, 0)
             |> part_1()
  end

  test "example - part 1 - 100 moves" do
    assert "67384529" ==
             @example
             |> play(100, 0)
             |> part_1()
  end

  test "day 23 - part 1" do
    assert "?" ==
             @my_input
             |> play(100, 0)
             |> part_1()
  end

  # Take all remaining cup numbers after cup 1.
  def part_1(cups) do
    cups
    |> Stream.cycle()
    |> Stream.drop_while(fn x -> x != 1 end)
    |> Stream.drop(1)
    |> Stream.take(8)
    |> Enum.join("")
  end

  def play(cups, max_turns, current_turn) when max_turns == current_turn do
    cups
  end

  def play([current_cup | remaining_cups] = cups, max_turns, current_turn) do
    picked_up =
      remaining_cups
      |> Enum.take(3)

    remaining_on_table =
      remaining_cups
      |> Enum.drop(3)
      |> Enum.take(5)

    destination = find_next_destination(current_cup, remaining_on_table)

    # Find the index of the destination in the remaining cups.
    insert_index = Enum.find_index(remaining_on_table, fn x -> x == destination end)

    # split the remaining cups into two lists, front and back, at the insert_index
    {front, back} = Enum.split(remaining_on_table, insert_index + 1)

    # construct the new order.  Putting current_cup on the end ensures the front of the list
    # will be the next current cup.
    new_order = front ++ picked_up ++ back ++ [current_cup]

    # run this function again on the new order, but increment turns by 1
    play(new_order, max_turns, current_turn + 1)
  end

  def find_next_destination(current_cup, remaining_cups) do
    current_cup =
      case current_cup - 1 do
        # if zero, wrap back to highest, which is 9
        0 -> 9
        # else, use current_cup - 1
        x -> x
      end

    candidate = current_cup

    if Enum.any?(remaining_cups, fn x -> x == current_cup end) do
      # candidate found, return the candidate value
      candidate
    else
      # candidate was not found, run this function again
      find_next_destination(current_cup, remaining_cups)
    end
  end
end
