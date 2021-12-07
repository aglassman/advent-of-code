defmodule Day07Test do
  use ExUnit.Case

  test "example" do
    assert 37 ==
             File.read!("input/7.example.txt")
             |> parse_input()
             |> least_fuel(:constant)
  end

  test "day 06 - part 1" do
    assert 328318 ==
             File.read!("input/7.txt")
             |> parse_input()
             |> least_fuel(:constant)
  end

  test "example 2" do
    assert 168 ==
             File.read!("input/7.example.txt")
             |> parse_input()
             |> least_fuel(:increasing)
  end

  test "day 06 - part 2" do
    assert 18864 ==
             File.read!("input/7.txt")
             |> parse_input()
             |> least_fuel(:increasing)
  end

  @doc """
  returns:
  %{ 1 => 23, 2 => 12}
  Where key is the remaining time, and value is the number of fish for that time.
  """
  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def least_fuel(input, calc_type) do
    {min, max} = Enum.min_max(input)
    frequencies = Enum.frequencies(input)

    min..max
    |> Enum.map(&total_fuel_cost(calc_type, frequencies, &1))
    |> Enum.min()
  end

  def total_fuel_cost(:constant, input, offset) do
    Enum.reduce(input, 0, fn {position, count}, acc ->
      acc + (count * abs(offset - position))
    end)
  end

  def total_fuel_cost(:increasing, input, offset) do
    Enum.reduce(input, 0, fn {position, count}, acc ->
      acc + (count * summation(abs(offset - position)))
    end)
  end

 def summation(0), do: 0
 def summation(n), do: n + summation(n-1)

end
