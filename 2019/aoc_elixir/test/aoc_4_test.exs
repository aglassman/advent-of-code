defmodule AocDay4ElixirTest do
  use ExUnit.Case
  doctest AocElixir4

  test "double digits" do
    assert true == AocElixir4.hasDoubleDigits("1423352")
    assert false == AocElixir4.hasDoubleDigits("142352")
  end

  test "never decreasing" do
    assert true == AocElixir4.neverDecreasing("123456")
    assert false == AocElixir4.neverDecreasing("1234565")
    assert false == AocElixir4.neverDecreasing("6543432")
  end

  test "chunk while" do

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

    double_count = "444479995522222"
    |> String.graphemes()
    |> Enum.chunk_while([], chunk_fun, after_fun)
    |> Enum.filter(fn chunk ->
      count = Enum.count(chunk) |> IO.inspect
      count > 1 and count < 3
      end)
    |> IO.inspect()
    |> Enum.count()

    assert 1 == double_count

  end

  test "Day 4: Part 1" do

    guesses = for guess <- 134564..585159, do: guess

    guesses
    |> Enum.map(&Integer.to_string/1)
    |> Enum.filter(&AocElixir4.hasDoubleDigits/1)
    |> Enum.filter(&AocElixir4.neverDecreasing/1)
    |> Enum.count()
    |> IO.inspect()

  end

  test "Day 4: Part 2" do
    guesses = for guess <- 134564..585159, do: guess

    guesses
    |> Enum.map(&Integer.to_string/1)
    |> Enum.filter(&AocElixir4.hasGroupWithOnlyTwoDigits/1)
    |> Enum.filter(&AocElixir4.neverDecreasing/1)
    |> Enum.count()
    |> IO.inspect()
  end

end
