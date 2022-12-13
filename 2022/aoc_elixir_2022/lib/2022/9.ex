import AOC

defmodule Rope do
  def new(rope_length \\ 1) do
    rope =
      for _i <- 0..rope_length do
        {0, 0}
      end

    %{rope: rope, head_path: [], tail_path: []}
  end

  def simulate_move({dx, dy}, [{hx, hy} | tail] = rope) do
    new_head = {hx + dx, hy + dy}

    {_, new_rope} =
      Enum.reduce([new_head | tail], {new_head, []}, fn tail, {head, acc} ->
        next = determine_tail(head, tail)
        {next, [next | acc]}
      end)

    Enum.reverse(new_rope)
  end

  def determine_tail({a, a}, {a, a}), do: {a, a}

  def determine_tail({hx, hy}, {tx, ty}) when abs(hx - tx) == 2 and abs(hy - ty) == 2 do
    dx =
      if hx - tx > 0 do
        1
      else
        -1
      end

    dy =
      if hy - ty > 0 do
        1
      else
        -1
      end

    {tx + dx, ty + dy}
  end

  def determine_tail({hx, hy}, {tx, ty}) when hy - ty == 2, do: {hx, hy - 1}
  def determine_tail({hx, hy}, {tx, ty}) when hy - ty == -2, do: {hx, hy + 1}
  def determine_tail({hx, hy}, {tx, ty}) when hx - tx == 2, do: {hx - 1, hy}
  def determine_tail({hx, hy}, {tx, ty}) when hx - tx == -2, do: {hx + 1, hy}
  def determine_tail(_head, tail), do: tail
end

aoc 2022, 9 do
  def p1(input) do
    %{tail_path: tail_path} =
      input
      |> parse()
      |> move(Rope.new())

    tail_path
    |> Enum.uniq()
    |> Enum.count()
  end

  # not 2297
  def p2(input) do
    %{tail_path: tail_path} =
      input
      |> parse()
      |> move(Rope.new(9))

    tail_path
    |> Enum.uniq()
    |> Enum.count()
  end

  def move([], state), do: state

  def move([move | moves], state) do
    state = move(move, state)
    move(moves, state)
  end

  def move({_, 0}, state), do: state

  def move({dir, dis}, %{rope: rope} = state) do
    rope = Rope.simulate_move(dir, rope)

    head = Enum.at(rope, 0)
    tail = Enum.at(rope, -1)

    state =
      state
      |> Map.put(:rope, rope)
      |> Map.update(:head_path, [head], fn path -> [head | path] end)
      |> Map.update(:tail_path, [tail], fn path -> [tail | path] end)

    move({dir, dis - 1}, state)
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split(&1, " "))
    |> Enum.map(fn [dir, dis] ->
      dis = String.to_integer(dis)

      dir =
        case dir do
          "L" -> {-1, 0}
          "R" -> {1, 0}
          "U" -> {0, -1}
          "D" -> {0, 1}
        end

      {dir, dis}
    end)
  end
end
