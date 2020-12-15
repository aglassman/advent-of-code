defmodule Day13Test do
  use ExUnit.Case

  import String, only: [to_integer: 1, replace: 3]
  import Integer, only: [parse: 2]
  import Bitwise

  @example """
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """

  @example_2 """
  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
  """

  test "example - part 1" do
    assert 165 == part_1(@example)
  end

  test "day 14 - part 1" do
    assert 13105044880745 == part_1(File.read!("input/14.txt"))
  end

  test "example - part 2" do
    assert 208 == part_2(@example_2)
  end

  test "day 14 - part 2" do
    assert 3505392154485 == part_2(File.read!("input/14.txt"))
  end

  def part_1(input) do
    input
    |> parse()
    |> run()
    |> sum_memory()
  end

  def part_2(input) do
    input
    |> parse()
    |> run_2()
    |> sum_memory()
  end

  def sum_memory(mem) do
    mem
    |> Enum.reject(&match?({:mask, _}, &1))
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  # part 2 run
  def run_2(instructions, mem \\ %{mask: nil})

  def run_2([], mem) do
    mem
  end

  def run_2([{:mask, _, _, _} = mask | instructions], mem) do
    run_2(instructions, %{mem | mask: mask})
  end

  def run_2([{:assign, location, value} | instructions], %{mask: {:mask, mask, m_or, _}} = mem) do
    mem = locations(bor(location, m_or), mask)
    |> Enum.reduce(mem, fn loc, mem -> put_in(mem, [loc], value) end)

    run_2(instructions, mem)
  end

  def locations(location, mask) do
    mask
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reject(fn {x, y} -> x != "X" end)
    |> Enum.map(fn {_, pos} -> [:math.pow(2, pos) |> trunc(), 0] end)
    |> Enum.reduce(fn p, acc ->
      for x <- p, y <- acc, do: List.flatten([x, y])
    end)
    |> Enum.map(fn list ->
      sum = Enum.sum(list)
      bor(location, sum) - band(location, sum)
    end)
  end


  # part 1 run
  def run(instructions, mem \\ %{mask: nil})

  def run([], mem) do
    mem
  end

  def run([{:mask, _, _, _} = mask | instructions], mem) do
    run(instructions, %{mem | mask: mask})
  end

  def run([{:assign, location, value} = mask | instructions], %{mask: {_, _, m_and, m_sub}} = mem) do
    output = bor(value, m_and) - band(value, m_sub)
    run(instructions, put_in(mem, [location], output))
  end

  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&to_instruction/1)
  end

  def to_instruction("mask = " <> mask) do

    {and_mask, _} = mask
    |> replace("X", "0")
    |> parse(2)

    {subtract_mask, _} = mask
    |> replace("X", "1")
    |> replace("0", "2")
    |> replace("1", "0")
    |> replace("2", "1")
    |> parse(2)

    {:mask, mask, and_mask, subtract_mask}
  end

  def to_instruction(assignment) do
    %{"l" => location, "v" => value} = Regex.named_captures(~r/mem\[(?<l>[\d]+)\] = (?<v>[\d]+)/, assignment)
    {:assign, to_integer(location), to_integer(value)}
  end
end