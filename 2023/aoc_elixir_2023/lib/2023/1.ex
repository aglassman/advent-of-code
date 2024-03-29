import AOC

aoc 2023, 1 do
  def p1(input) do
    input
    |> String.split("\n")
    |> identify_and_sum()
  end

  def p2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&replace/1)
    |> identify_and_sum()
  end

  def is_int(val) do
    case Integer.parse(val) do
      {int, _} -> true
      _ -> false
    end
  end

  def identify_and_sum(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> Enum.reduce(0, fn line, sum ->
      first = Enum.find(line, &is_int/1)
      last = line |> Enum.reverse() |> Enum.find(&is_int/1)
      {int, _} = Integer.parse(first <> last)
      sum + int
    end)
  end

  @replacements %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }
  @regex ~r/one|two|three|four|five|six|seven|eight|nine/

  def replace(line) do
    case Regex.replace(@regex, line, fn a -> Map.get(@replacements, a) end) do
      new_line = ^line -> line
      new_line -> replace(new_line)
    end
  end
end
