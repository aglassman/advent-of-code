defmodule Day09Test do
  use ExUnit.Case

  @example """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """

  test "example - part 1" do
    assert 127 = find_missing(@example, 5)
  end

  test "day 9 - part 1" do
    assert 1_492_208_709 = find_missing(File.read!("input/9.txt"), 25)
  end

  test "example - part 2" do
    assert 62 = find_weakness(@example, 127)
  end

  test "day 9 - part 2" do
    assert 238_243_506 = find_weakness(File.read!("input/9.txt"), 1_492_208_709)
  end

  def find_missing(input, preamble_size) do
    to_int_stream(input, preamble_size + 1)
    |> Stream.map(&Enum.reverse/1)
    |> Enum.find_value(fn [sum | remaining] ->
      case find_sums_2(remaining, sum) do
        :not_found -> sum
        _ -> nil
      end
    end)
  end

  def find_weakness(input, target) when is_binary(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> find_weakness(target)
  end

  def find_weakness(input, target, start_index \\ 0, amount \\ 1) do
    to_check = Enum.slice(input, start_index, amount)
    sum = Enum.sum(to_check)

    cond do
      sum == target -> Enum.min(to_check) + Enum.max(to_check)
      start_index + amount > Enum.count(input) -> :not_found
      sum < target -> find_weakness(input, target, start_index, amount + 1)
      sum > target -> find_weakness(input, target, start_index + 1, amount - 1)
    end
  end

  def to_int_stream(input, window_size) do
    String.split(input, "\n", trim: true)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(window_size, 1)
  end

  def find_sums_2(input, sum) do
    input = :lists.usort(input)

    try do
      for a <- input, b <- input do
        cond do
          a != b and a + b == sum -> throw({:found, {a, b}})
          true -> nil
        end
      end

      :not_found
    catch
      {:found, answer} -> {:found, answer}
    end
  end
end
