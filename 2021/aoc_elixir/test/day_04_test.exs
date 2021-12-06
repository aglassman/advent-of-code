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
    assert 67716 ==
             File.read!("input/4.txt")
             |> parse_input()
             |> play_bingo()
             |> score()
  end

  test "example 2" do
    assert 1924 ==
             File.read!("input/4.example.txt")
             |> parse_input()
             |> play_bingo(_wins = [])
             |> score()
  end

  test "day 04 - part 2" do
    assert 1830 ==
             File.read!("input/4.txt")
             |> parse_input()
             |> play_bingo(_wins = [])
             |> score()
  end

  @doc """
  returns:
  {_sequence = [int()], _boards = [map()]}
  """
  def parse_input(input) do
    [sequence_string | board_strings] = String.split(input, "\n\n", trim: true)

    sequence =
      sequence_string
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    boards = Enum.map(board_strings, &string_to_board/1)

    {sequence, boards}
  end

  def score(wins) when is_list(wins) do
    wins
    |> Enum.at(-1)
    |> IO.inspect(charlists: :as_lists)
    |> score()
  end

  # score one game
  def score({called_numbers, last_called, winning_row, board}) do
    unmarked_sum =
      board
      |> Enum.flat_map(fn x -> x end)
      |> MapSet.new()
      |> MapSet.difference(called_numbers)
      |> Enum.reduce(&+/2)

    unmarked_sum * last_called
  end

  def string_to_board(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(fn row_string ->
      row_string
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  If wins == nil, result will be tuple:
  {called_numbers :: MapSet.t(), to_call :: integer(), winning_numbers :: [integer()], winning_board :: [[integer()], ...]}

  If wins is a list, result will be list of winning tuples:
  [{...}, {...}, ...]
  """
  def play_bingo({to_call, boards}, wins \\ nil) do
    play_bingo(to_call, MapSet.new(), boards, wins)
  end

  def play_bingo(to_call, called_numbers, [], wins) do
    wins
  end

  def play_bingo([], called_numbers, boards, wins) do
    wins
  end

  def play_bingo([to_call | remaining_calls], called_numbers, boards, wins) do
    called_numbers = MapSet.put(called_numbers, to_call)

    case find_winners(called_numbers, boards, to_call) do
      [] ->
        play_bingo(remaining_calls, called_numbers, boards, wins)

      winners = [win | _] ->
        if wins do
          new_winners =
            winners
            |> Enum.map(fn winner ->
              {called_numbers, winning_numbers, winning_board} = winner

              win =
                {called_numbers, to_call, winning_numbers, winning_board}
                |> IO.inspect(charlists: :as_lists)
            end)

          winning_boards = Enum.map(winners, fn {_, _, board} -> board end)

          # remove board that has won
          remaining_boards =
            Enum.reject(boards, fn board -> Enum.any?(winning_boards, fn x -> x == board end) end)

          play_bingo(remaining_calls, called_numbers, remaining_boards, wins ++ new_winners)
        else
          win
        end
    end
  end

  def find_winners(called_numbers, boards, to_call) do
    row_wins =
      boards
      |> Enum.map(&horizontal_win(called_numbers, &1, to_call))
      |> Enum.reject(&is_nil/1)

    column_wins =
      boards
      |> Enum.map(&vertical_win(called_numbers, &1, to_call))
      |> Enum.reject(&is_nil/1)

    (row_wins ++ column_wins)
    |> Enum.map(fn winner ->
      {winning_numbers, winning_board} = winner
      {called_numbers, winning_numbers, winning_board}
    end)
  end

  def horizontal_win(called_numbers, board, to_call) do
    board
    |> Enum.find_value(fn row ->
      row
      |> MapSet.new()
      |> MapSet.subset?(called_numbers)
      |> if do
        if Enum.any?(row, fn x -> x == to_call end) do
          {row, board}
        else
          nil
        end
      else
        nil
      end
    end)
  end

  def vertical_win(called_numbers, board, to_call) do
    board
    |> Enum.zip()
    |> Enum.find_value(fn column ->
      column
      |> Tuple.to_list()
      |> MapSet.new()
      |> MapSet.subset?(called_numbers)
      |> if do
        if Enum.any?(column |> Tuple.to_list(), fn x -> x == to_call end) do
          {column |> Tuple.to_list(), board}
        else
          nil
        end
      else
        nil
      end
    end)
  end
end
