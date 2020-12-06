defmodule Day06Test do
  use ExUnit.Case

  @example """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """

  test "example - part 1" do
    assert 11 = sum_p1(@example |> String.trim())
  end

  test "day 1 - part 1" do
    assert 6809 = sum_p1(File.read!("input/6.txt"))
  end

  test "example - part 2" do
    assert 6 = sum_p2(@example |> String.trim())
  end

  test "day 1 - part 2" do
    assert 3394 = sum_p2(File.read!("input/6.txt"))
  end

  def sum_p1(inputs) do
    String.split(inputs, "\n\n")
    |> Stream.map(fn input ->
      input
      |> String.graphemes()
      |> Enum.reject(&(&1 == "\n"))
    end)
    |> Stream.map(&:lists.usort/1)
    |> Stream.map(&Enum.count/1)
    |> Enum.sum()
  end

  def sum_p2(inputs) do
    String.split(inputs, "\n\n")
    |> Stream.map(fn input ->
      input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
    end)
    |> Stream.map(&Enum.count/1)
    |> Enum.sum()
  end
end
