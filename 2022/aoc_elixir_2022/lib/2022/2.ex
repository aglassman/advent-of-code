import AOC

aoc 2022, 2 do
  def p1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [a, b] ->
      {p1_map(a), p1_map(b)}
    end)
    |> Enum.map(&score_game/1)
    |> Enum.sum()
  end

  def p2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [a, b] ->
      {p1_map(a), p2_map(p1_map(a), b)}
    end)
    |> Enum.map(&score_game/1)
    |> Enum.sum()
  end

  @win 6
  @tie 3
  @loss 0

  def score_game({a, a}), do: @tie + points(a)
  def score_game({a, b}), do: (if beats(a) == b do @loss else @win end) + points(b)

  def points(:rock), do: 1
  def points(:paper), do: 2
  def points(:scissors), do: 3

  def beats(:rock), do: :scissors
  def beats(:paper), do: :rock
  def beats(:scissors), do: :paper

  def beat_by(:rock), do: :paper
  def beat_by(:paper), do: :scissors
  def beat_by(:scissors), do: :rock

  def p1_map(a) when a in ["A", "X"], do: :rock
  def p1_map(a) when a in ["B", "Y"], do: :paper
  def p1_map(a) when a in ["C", "Z"], do: :scissors

  def p2_map(a, "X"), do: beats(a)
  def p2_map(a, "Y"), do: a
  def p2_map(a, "Z"), do: beat_by(a)

end
