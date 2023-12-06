import AOC

aoc 2023, 6 do
  @moduledoc """
  https://adventofcode.com/2023/day/6
  """

  def parse_1(input) do
    nums =
      Regex.scan(~r/[\d]+/, input)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    Enum.chunk_every(nums, trunc(length(nums) / 2))
  end

  def parse_2(input) do
    nums =
      Regex.scan(~r/[\d]+/, input)
      |> List.flatten()

    nums
    |> Enum.chunk_every(trunc(length(nums) / 2))
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer/1)
  end

  def count_wins(time, record) do
    for hold <- 1..(time - 1), reduce: 0 do
      win_options ->
        distance = (time - hold) * hold
        if distance > record do
          win_options +  1
        else
          win_options
        end
    end
  end

  @doc """
      iex> p1(example_input())
  """
  def p1(input) do
    for {time, record} <- Enum.zip(parse_1(input)), reduce: 1 do
      product ->
        count_wins(time, record) * product
    end

  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    [time, record] = parse_2(input)
    count_wins(time, record)
  end
end
