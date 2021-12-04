defmodule Day04Test do
  use ExUnit.Case
  use Bitwise


  test "example" do
    assert 4512 ==
             File.read!("input/4.example.txt")
             |> parse_input()
             |> play_bingo()
             |> score()
  end

  test "day 04 - part 1" do
    assert 4512 ==
             File.read!("input/4.txt")
             |> parse_input()
             |> play_bingo()
             |> score()
  end

  test "example 2" do

  end

  test "day 04 - part 2" do

  end

  @doc """
  returns:
  {_sequence = [int()], _boards = [map()]}
  """
  def parse_input(input) do
    [sequence_string | board_strings] = String.split(input, "\n\n", trim: true)

    sequence = sequence_string
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)

    boards = Enum.map(board_strings, &string_to_board/1)

    {sequence, boards}
  end

  def score({called_numbers, last_called, winning_row, board}) do
    unmarked_sum = board
    |> Enum.flat_map(fn x -> x end)
    |> MapSet.new()
    |> MapSet.difference(called_numbers)
    |> Enum.reduce(&+/2)

    unmarked_sum * last_called
  end

  def string_to_board(string) do
    string
    |> IO.inspect()
    |> String.split("\n", trim: true)
    |> Enum.map(fn row_string ->
      row_string
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def play_bingo({to_call, boards}) do
    play_bingo(to_call, MapSet.new(), boards)
  end

  def play_bingo([], called_numbers, boards) do
    :no_winners
  end

  def play_bingo([to_call | remaining_calls], called_numbers, boards) do
    called_numbers = MapSet.put(called_numbers, to_call)
    case find_winner(called_numbers, boards) do
      {:found, called_numbers, winning_numbers, winning_board} ->
        {called_numbers, to_call, winning_numbers, winning_board}
      :no_winners ->
        play_bingo(remaining_calls, called_numbers, boards)
    end
  end

  def find_winner(called_numbers, boards) do
    row_wins = Enum.find_value(boards, &horizontal_win(called_numbers, &1))
    column_wins = Enum.find_value(boards, &vertical_win(called_numbers, &1))

    if winner = Enum.find([row_wins, column_wins], fn winner -> !is_nil(winner) end) do
      {winning_numbers, winning_board} = winner
      {:found, called_numbers, winning_numbers, winning_board}
    else
      :no_winners
    end

  end

  def horizontal_win(called_numbers, board) do
    board
    |> Enum.find_value(fn row ->
      row
      |> MapSet.new()
      |> MapSet.subset?(called_numbers)
      |> if do
           {row, board}
        else
            nil
        end
    end)
  end

  def vertical_win(called_numbers, board) do
    board
    |> Enum.zip()
    |> Enum.find_value(fn column ->
      column
      |> Tuple.to_list()
      |> MapSet.new()
      |> MapSet.subset?(called_numbers)
      |> if do
           {column, board}
         else
           nil
         end
    end)
  end

end
