import AOC

aoc 2023, 15 do
  @moduledoc """
  https://adventofcode.com/2023/day/15
  """

  def hash(str, current_value \\ 0) when is_binary(str) do
    hash(String.to_char_list(str))
  end

  def hash([], current_value), do: current_value

  def hash([h | t], current_value) do
    hash(t, rem((current_value + h) * 17, 256))
  end

  def operation("-", label, lenses) do
    if Keyword.has_key?(lenses, label) do
      {lens, lenses} = pop_in(lenses, [label])
      lenses
    else
      lenses
    end
  end

  def operation("=", {label, focal_length}, lenses) do
    if Keyword.has_key?(lenses, label) do
      Keyword.replace(lenses, label, focal_length)
    else
      Keyword.put(lenses, label, focal_length)
    end
  end

  def focusing_power({{label, focal_length}, slot}, box) do
    (1 + box) * slot * focal_length
  end

  def focusing_power({box, lenses}) do
    lenses
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(&focusing_power(&1, box))
    |> Enum.sum()
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    input
    |> String.split(",")
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do

    input
    |> String.split(",")
    |> Enum.map(&String.split(&1, "="))
    |> Enum.reduce(%{}, fn
      [label, lens], boxes ->
        Map.update(
          boxes,
          hash(label),
          [{String.to_atom(label), String.to_integer(lens)}],
          &operation("=", {String.to_atom(label), String.to_integer(lens)}, &1))

      [label_and_op], boxes ->
        label = String.replace_trailing(label_and_op, "-", "")
        Map.update(
          boxes,
          hash(label),
          [],
          &operation("-", String.to_atom(label), &1))
    end)
    |> Enum.map(&focusing_power/1)
    |> Enum.sum()
  end
end
