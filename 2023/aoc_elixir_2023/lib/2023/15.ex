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
    current_value = current_value + h
    current_value = current_value * 17
    current_value = rem(current_value, 256)
    hash(t, current_value)
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

  def focusing_power({box, lenses}) do
    for {{label, focal_length}, slot} <- lenses |> Enum.reverse() |> Enum.with_index(1), reduce: 0 do
      total -> total + ((1 + box) * slot * focal_length)
    end
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
    |> Enum.reduce(0, fn {box, lenses}, total ->
        total + focusing_power({box, lenses})
    end)
  end
end
