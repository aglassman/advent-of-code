defmodule Day13Test do
  use ExUnit.Case

  @example """
  939
  7,13,x,x,59,x,31,19
  """

  @example_2 """
  939
  17,x,13,19
  """

  test "example - part 1" do
    assert 295 = part_1(@example)
  end

  test "day 13 - part 1" do
    assert 4135 = part_1(File.read!("input/13.txt"))
  end

  test "example 1 - part 2" do
    assert 1_068_781 = part_2(@example)
  end

  test "example 2 - part 2" do
    assert 3417 = part_2(@example_2)
  end

  @tag timeout: :infinity
  test "day 13 - part 2" do
    assert 3417 = part_2(File.read!("input/13.txt"))
  end

  def part_1(input) do
    {next_bus, wait_time} =
      input
      |> parse()
      |> next_bus()

    next_bus * wait_time
  end

  # Chinese Remainder Theorem
  # https://rosettacode.org/wiki/Chinese_remainder_theorem
  def part_2(input) do
    {_, busses} = parse(input)

    indexed_busses =
      busses
      |> Stream.with_index()
      |> Enum.reject(&match?({:x, _}, &1))

    n =
      indexed_busses
      |> Stream.map(fn {bus_id, _} -> bus_id end)
      |> Enum.reduce(&*/2)
      |> IO.inspect()

    sum =
      indexed_busses
      |> Enum.map(fn {bus_id, i} ->
        p = trunc(n / bus_id)
        r = bus_id - i

        a =
          case extended_gcd(p, bus_id) do
            %{s: s} when s < 0 -> r * (s + bus_id) * p
            %{s: s} -> r * s * p
          end
      end)
      |> Enum.sum()
      |> rem(n)
  end

  # extended euclidean algorithm
  # calculates greatest common divisor, and coefficients of Bezout's identity
  # such that ax + by = gcd(a,b)
  # https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
  def extended_gcd(a, b) do
    iterate_egcd(0, a, b, 1, 0, 0, 1)
  end

  def iterate_egcd(q, old_r, 0 = r, old_s, s, old_t, t) do
    %{r: old_r, s: old_s, t: old_t}
  end

  def iterate_egcd(q, old_r, r, old_s, s, old_t, t) do
    q = trunc(old_r / r)

    iterate_egcd(
      q,
      r,
      old_r - q * r,
      s,
      old_s - q * s,
      t,
      old_t - q * t
    )
  end

  # part 1
  def next_bus({earliest_departure, busses}) do
    next_bus =
      busses
      |> Enum.reject(&(&1 == :x))
      |> Enum.min_by(&minutes_to_departure(earliest_departure, &1))

    {next_bus, minutes_to_departure(earliest_departure, next_bus)}
  end

  def minutes_to_departure(time, bus_id) do
    case rem(time, bus_id) do
      0 -> 0
      x -> bus_id - x
    end
  end

  def parse(input) do
    [earliest_departure, busses] = String.split(input, "\n", trim: true)

    earliest_departure = String.to_integer(earliest_departure)

    busses =
      busses
      |> String.split(",")
      |> Enum.map(fn x ->
        case Integer.parse(x) do
          {val, _} -> val
          _ -> :x
        end
      end)

    {earliest_departure, busses}
  end
end
