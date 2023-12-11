import AOC

aoc 2023, 9 do
  @moduledoc """
  https://adventofcode.com/2023/day/9
  """

  def decompose(sequence, history) do
    reduced = sequence
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)

    if Enum.all?(reduced, &(&1 == 0)) do
      [sequence | history]
    else
      decompose(reduced, [sequence | history])
    end
  end

  def predict([], diff), do: diff

  def predict([sequence | decomp], diff) do
    predict(decomp, List.last(sequence) + diff)
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    input
    |> String.split("\n")
    |> Stream.map(&(&1 |> String.split(" ") |> Enum.map(fn x -> String.to_integer(x) end)))
    |> Stream.map(fn sequence -> decompose(sequence, []) end)
    |> Stream.map(fn decomp -> predict(decomp, 0) end)
    |> Enum.sum()
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    input
    |> String.split("\n")
    |> Stream.map(&(&1 |> String.split(" ") |> Enum.map(fn x -> String.to_integer(x) end)))
    |> Stream.map(&Enum.reverse/1)
    |> Stream.map(fn sequence -> decompose(sequence, []) end)
    |> Stream.map(fn decomp -> predict(decomp, 0) end)
    |> Enum.sum()
  end
end
