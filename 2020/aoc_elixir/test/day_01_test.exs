defmodule Day01Test do
  use ExUnit.Case

  test "example" do
    {factor_1, factor_2} =
      input_to_list(File.read!("input/1.example.txt"))
      |> find_sums_2(2020)

    assert factor_1 == 1721
    assert factor_2 == 299

    answer = 514_579

    assert answer == factor_1 * factor_2
  end

  test "day 01 - part 1" do
    {factor_1, factor_2} =
      answer =
      input_to_list(File.read!("input/1.txt"))
      |> find_sums_2(2020)

    IO.inspect("Day 01 Answer - part 1: #{inspect(answer)} sum: #{factor_1 * factor_2}")
    assert 157_059 = factor_1 * factor_2
  end

  test "day 01 - part 2" do
    [{factor_1, factor_2, factor_3} | _] =
      answer =
      input_to_list(File.read!("input/1.txt"))
      |> find_sums_3(2020)

    IO.inspect(
      "Day 01 Answer - part 2: #{inspect(answer)} sum: #{factor_1 * factor_2 * factor_3}"
    )

    assert 165_080_960 = factor_1 * factor_2 * factor_3
  end

  def input_to_list(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def find_sums_2(input, sum) do
    try do
      for {a, ai} <- Enum.with_index(input), {b, bi} <- Enum.with_index(input) do
        cond do
          ai != bi and a + b == sum -> throw({:found, {a, b}})
          true -> nil
        end
      end
    catch
      {:found, answer} -> answer
    end
  end

  def find_sums_3(input, sum) do
    for {a, ai} <- Enum.with_index(input),
        {b, bi} <- Enum.with_index(input),
        {c, ci} <- Enum.with_index(input) do
      cond do
        ai != bi and bi != ci and a + b + c == sum -> {a, b, c}
        true -> nil
      end
    end
    |> Enum.reject(&is_nil/1)
  end
end
