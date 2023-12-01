import AOC

aoc 2023, 1 do

  def is_int(val) do
    case Integer.parse(val) do
      {int, _} -> true
      _ -> false
    end
  end

  def p1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.reduce(0, fn line, sum ->
      first = Enum.find(line, &is_int/1)
      last = line |> Enum.reverse() |> Enum.find(&is_int/1)
      {int, _} = Integer.parse(first <> last)
      sum + int
    end)
  end

  def p2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&replace/1)
    |> Enum.map(&String.graphemes/1)
    |> Enum.reduce(0, fn line, sum ->
      first = Enum.find(line, &is_int/1)
      last = line |> Enum.reverse() |> Enum.find(&is_int/1)
      {int, _} = Integer.parse(first <> last)
      sum + int
    end)
  end

  @replacements [
            {"one", "1"},
            {"two", "2"},
            {"three", "3"},
            {"four", "4"},
            {"five", "5"},
            {"six", "6"},
            {"seven", "7"},
            {"eight", "8"},
            {"nine", "9"},
          ] |> Map.new()

  @regex ~r/one|two|three|four|five|six|seven|eight|nine/

  def replace(line) do
    new_line = Regex.replace(@regex, line, fn a -> Map.get(@replacements, a) end)
    cond do
      new_line == line -> line
      true -> replace(new_line)
    end
  end
end
