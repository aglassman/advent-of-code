defmodule Day02Test do
  use ExUnit.Case
  use Bitwise
  doctest AocElixir

  test "example" do
    input = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

    input_stream = parse_and_validate_input(input, &validate_password_count/1)

    valid = input_stream |> Stream.reject(&(match?({:invalid, _}, &1)))

    assert 2 == valid |> Enum.count()
  end

  test "day 2 - part 1" do
    input = File.read!("input/2.txt")

    input_stream = parse_and_validate_input(input, &validate_password_count/1)

    valid = input_stream |> Stream.reject(&(match?({:invalid, _}, &1)))

    assert 530 == valid |> Enum.count()
  end

  test "day 2 - part 2" do
    input = File.read!("input/2.txt")

    input_stream = parse_and_validate_input(input, &validate_password_position/1)

    valid = input_stream |> Stream.reject(&(match?({:invalid, _}, &1)))

    assert 1000 == valid |> Enum.count()
  end

  @regex ~r/(?<min>[\d]+)-(?<max>[\d]+) (?<char>.+): (?<password>.*)/

  def parse_and_validate_input(string, validator) do
    string
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&(Regex.named_captures(@regex, &1)))
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn %{"char" => char, "max" => max, "min" => min, "password" => password} ->
      %{
        char: char,
        min: String.to_integer(min),
        max: String.to_integer(max),
        password: password
      }
    end)
    |> Stream.map(validator)
  end

  def validate_password_count(%{char: char, min: min, max: max, password: password} = match) do
    count = String.graphemes(password)
    |> Stream.reject(&(char != &1))
    |> Enum.count()

    if count >= min && count <= max do
      {:valid, match}
    else
      {:invalid, match}
    end
  end

  def validate_password_position(%{char: char, min: min, max: max, password: password} = match) do
    graphemes = String.graphemes(password)
    a = Enum.at(graphemes, min - 1) == char
    b = Enum.at(graphemes, max - 1) == char

    if (a || b) && !(a && (a == b)) do
      {:valid, match}
    else
      {:invalid, match}
    end
  end

end