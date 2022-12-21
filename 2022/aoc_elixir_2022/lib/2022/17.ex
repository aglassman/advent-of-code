import AOC

aoc 2022, 17 do

  @a [{0,0},{1,0},{2,0},{3,0}]
  @b [{1,0},{0,1},{1,1},{2,1},{1,2}]
  @c [{0,0},{1,0},{2,0},{2,1},{2,2}]
  @d [{0,0},{0,1},{0,2},{0,3}]
  @e [{0,0},{1,0},{0,1},{1,1}]

  @blocks [@a, @b, @c, @d, @e]

  def p1(input) do
    wind = parse(input)
    chamber = new_chamber()
    state = fall(chamber, @blocks, wind, 1000000000000) + 1
  end

  def p2(input) do
  end

  def new_chamber() do
    %{falling: nil, fallen: [], width: 7, max_height: 0}
  end

  def fall(%{falling: nil, fallen: [last | _] = fallen} = s, _blocks, _wind, max) when length(fallen) == max do
    s[:max_height]
  end

  def fall(%{falling: nil} = s, [block | blocks], wind, max) do
#    IO.inspect(block, label: :next_block)
    fall(set_start(s, block), blocks ++ [block], wind, max)
  end

  def fall(%{falling: falling, fallen: fallen} = s, blocks, [direction | wind] = w, max) do
#    IO.inspect([ length(fallen), direction, falling], label: :fall)
#    print(s, falling)
    delta = case direction do
      "v" -> {0, -1}
      "<" -> {-1, 0}
      ">" -> {1, 0}
    end

    next = transpose(delta, falling)
    move = can_move?(s, next)

    cond do
      !move and direction == "v" ->
#        IO.inspect([move, direction], label: :stopping)
        falling
        |> Enum.reduce(s, fn {x, y}, s -> Map.put(s, {x, y}, "#") end)
        |> Map.put(:falling, nil)
        |> Map.update(:fallen, [], fn fallen -> [falling | fallen] end)
        |> Map.update(:max_height, 0, fn previous -> max(previous, height(falling)) end)
        |> fall(blocks, wind ++ [direction], max)
      !move ->
#        IO.inspect([move, direction], label: :not_moving)
        fall(%{s | falling: falling}, blocks, wind ++ [direction], max)

      true ->
#        IO.inspect([move, direction], label: :moving)
        fall(%{s | falling: next}, blocks, wind ++ [direction], max)
    end
  end

  def can_move?(state, block) do
    !Enum.any?(block, fn {x,y} ->
      y <= -1 or x < 0 or x > 6 or Map.has_key?(state, {x, y})
    end)
  end

  def set_start(%{fallen: []} = s, block) do
    new_block = transpose({2, 3}, block)
#    IO.inspect(new_block, label: :new_block_start)
    %{s | falling: new_block}
  end

  def set_start(%{fallen: [last | _], max_height: max_height} = s, block) do
    start_height = max_height + 4
    new_block = transpose({2, start_height}, block)
#    IO.inspect(new_block, label: :new_block)
    %{s | falling: new_block}
  end

  def transpose({sx, sy}, block) do
    Enum.map(block, fn {x, y} -> {x + sx, y + sy} end)
  end

  def height(fallen) do
    {_, y} = Enum.max_by(fallen, fn {_, y} -> y end)
    y
  end

  def print(s, falling) do
    s = Enum.reduce(falling, s, fn c, s -> Map.put(s, c, "@") end)
    IO.puts("---------------------")
    for  y <- 20..0, x <- 0..6 do
      Map.get(s, {x, y}, ".")
    end
    |> Enum.chunk_every(7,7)
    |> Enum.each(&IO.puts/1)
  end

  def parse(input) do
    input
    |> String.replace("","v")
    |> String.graphemes()
    |> Enum.drop(1)
  end
end
