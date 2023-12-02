import AOC

aoc 2023, 2 do
  @moduledoc """
  https://adventofcode.com/2023/day/2
  """

  def parse_games(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn "Game " <> rest -> String.split(rest, ":") end)
    |> Enum.map(fn [id, games] -> {String.to_integer(id), String.split(games, ";")} end)
    |> Enum.map(fn {id, games} -> {id, Enum.map(games, &parse_game/1)} end)
  end

  def parse_game(game) do
    game
    |> String.split(",")
    |> Enum.map(fn game ->
      [count, color] =
        game
        |> String.trim()
        |> String.split(" ")

      {color, String.to_integer(count)}
    end)
  end

  @doc """
      iex> p1(example_input())
      # 12 red cubes, 13 green cubes, and 14 blue cubes
  """
  def p1(input) do
    max = %{"red" => 12, "green" => 13, "blue" => 14}

    input
    |> parse_games()
    |> Enum.reduce(0, fn {id, games} = this, id_sum ->
      case for game <- games, {color, count} <- game, count > Map.get(max, color), do: true do
        [] -> id_sum + id
        _ -> id_sum
      end
    end)
  end

  @doc """
      iex> p2(example_input())
  """
  def p2(input) do
    input
    |> parse_games()
    |> Enum.reduce(0, fn {id, games} = this, power_sum ->
      grouped_games = games |> List.flatten() |> Enum.group_by(fn {color, _} -> color end)
      max_reds = Enum.max_by(grouped_games["red"], fn {_, count} -> count end) |> elem(1)
      max_greens = Enum.max_by(grouped_games["green"], fn {_, count} -> count end) |> elem(1)
      max_blues = Enum.max_by(grouped_games["blue"], fn {_, count} -> count end) |> elem(1)
      power_sum + max_reds * max_greens * max_blues
    end)
  end
end
