import AOC

aoc 2022, 13 do
  def p1(input) do
    input
    |> parse()
    |> Enum.map(&verify_order/1)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {result, i}, acc ->
      if result do
        acc + i
      else
        acc
      end
    end)

  end

  def p2(input) do
    dividers = [[[2]], [[6]]]

    input
    |> parse()
    |> Enum.concat()
    |> Enum.concat(dividers)
    |> Enum.sort(&verify_order/2)
    |> Enum.with_index(1)
    |> Enum.reduce(1, fn {packet, i}, acc ->
      if packet in dividers do
        acc * i
      else
        acc
      end
    end)
  end

  def verify_order(a, b), do: verify_order([a, b])

  def verify_order([a, b]) when is_list(a) and is_integer(b) do
    verify_order([a, [b]])
  end

  def verify_order([a, b]) when is_integer(a) and is_list(b) do
    verify_order([[a], b])
  end

  def verify_order([a , b]) when is_integer(a) and is_integer(b) do
    cond do
      a < b -> true
      a > b -> false
      a == b -> :continue
    end
  end

  def verify_order([[], [_ | _]]), do: true
  def verify_order([[_ | _], []]), do: false
  def verify_order([[], []]), do: :continue

  def verify_order([[a | at], [b | bt]]) do
    case verify_order([a, b]) do
      :continue ->
        verify_order([at, bt])
      result ->
        result
    end
  end

  def parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn group ->
      group
      |> String.split("\n")
      |> Enum.map(fn line ->
        {packet, _} = Code.eval_string(line)
        packet
      end)
    end)
  end
end
