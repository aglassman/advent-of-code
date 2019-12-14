defmodule AocElixir4 do
  @moduledoc """
  Documentation for AocElixir4.
  """

  def hasDoubleDigits(passwordGuess) do


    double_digit_count = passwordGuess
    |> String.graphemes()
    |> Enum.chunk_every(2,1, :discard)
    |> Enum.filter(fn val ->
        List.first(val) == List.last(val)
      end)
    |> Enum.count()

    double_digit_count > 0

  end

  def neverDecreasing(passwordGuess) do

    decreasing_count = passwordGuess
    |> String.graphemes()
    |> Enum.chunk_every(2,1, :discard)
    |> Enum.filter(fn val ->
      !(List.first(val) <= List.last(val))
    end)
    |> Enum.count()

    decreasing_count == 0

  end

  def hasGroupWithOnlyTwoDigits(passwordGuess) do

    chunk_fun = fn element, acc ->
      cond do
        acc == [] -> {:cont, [element]}
        List.last(acc) == element -> {:cont, acc ++ [element]}
        true -> {:cont, acc, [element]}
      end
    end

    after_fun = fn
      chunk -> {:cont, chunk, chunk}
    end

    double_count = passwordGuess
     |> String.graphemes()
     |> Enum.chunk_while([], chunk_fun, after_fun)
     |> Enum.filter(fn chunk ->
          Enum.count(chunk) == 2
        end)
     |> Enum.count()

    double_count > 0

  end

end