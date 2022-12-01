defmodule Day24Test do
  use ExUnit.Case

  @tag timeout: :infinity
  test "part 1" do

    program = input()
    |> parse()

    guess = for i <- 1..14, into: [], do: 9

    solution = find_solution(program, guess)

    assert "9999" ==  solution |> Enum.join("")

  end

  def find_solution(program, guess) do

    case execute(program, guess) do
      %{solution: solution} when length(solution) == 14 ->
        solution

      %{interrupt: true, solution: solution} ->
        [g | gtail] = Enum.drop(guess, length(solution))
        new_guess = if (g - 1) > 0 do
          solution ++ [g - 1 | gtail]
        else
          [g | gtail] = gtail
          solution ++ [g | gtail]
        end
        IO.inspect([length(solution), g - 1])
        find_solution(program, new_guess)
    end

  end

  def lookup(state, b) when is_atom(b), do: state[b]
  def lookup(_state, b), do: b

  def execute(program, inputs, state \\ %{w: 0, x: 0, y: 0, z: 0})

  def execute([], _, state), do: state

  def execute([[:inp, var] = i | program], [input | inputs], state) do
    if state.z != 0 do
      Map.put(state, :interrupt, true)
    else
      state = state
              |> Map.put(var, input)
              |> Map.update(:solution, [input], &(&1 ++ [input]))
      execute(program, inputs, state)
    end
  end

  def execute([[inst, a, b] = i | program], inputs, state) do
    result = case inst do
      :add ->
        state[a] + lookup(state, b)
      :mul ->
        state[a] * lookup(state, b)
      :div ->
        trunc(state[a] / lookup(state, b))
      :mod ->
        rem(state[a], lookup(state, b))
      :eql ->
        if state[a] == lookup(state, b) do 1 else 0 end
    end
    state =  Map.put(state, a, result)
    #IO.inspect(%{inst: i, result: result, state: state})
    execute(program, inputs, state)
  end



  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [op | args] = String.split(line, " ")
      [String.to_atom(op) | parse_args(args)]
    end)
  end

  def parse_args(args) do
    for arg <- args do
      case Integer.parse(arg) do
        :error ->
          String.to_atom(arg)

        {int, _} ->
          int
      end
    end
  end


  @step_4 [
    [:div, :z, 1],
    [:div, :z, 1],
    [:div, :z, 1],
    [:div, :z, 26],
    [:div, :z, 1],
    [:div, :z, 26],
    [:div, :z, 1],
    [:div, :z, 26],
    [:div, :z, 1],
    [:div, :z, 1],
    [:div, :z, 26],
    [:div, :z, 26],
    [:div, :z, 26],
    [:div, :z, 26]
  ]

  @step_5 [
    [:add, :x, 10],
    [:add, :x, 13],
    [:add, :x, 15],
    [:add, :x, -12],
    [:add, :x, 14],
    [:add, :x, -2],
    [:add, :x, 13],
    [:add, :x, -12],
    [:add, :x, 15],
    [:add, :x, 11],
    [:add, :x, -3],
    [:add, :x, -13],
    [:add, :x, -12],
    [:add, :x, -13]
  ]

  @step_15 [
    [:add, :y, 10],
    [:add, :y, 5],
    [:add, :y, 12],
    [:add, :y, 12],
    [:add, :y, 6],
    [:add, :y, 4],
    [:add, :y, 15],
    [:add, :y, 3],
    [:add, :y, 7],
    [:add, :y, 11],
    [:add, :y, 2],
    [:add, :y, 12],
    [:add, :y, 4],
    [:add, :y, 11]
  ]


  def input(), do: """
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 10
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 10
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 5
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 15
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 12
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -12
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 12
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 14
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 6
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -2
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 4
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 15
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -12
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 3
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 15
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 7
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 1
  add x 11
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 11
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -3
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 2
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 12
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -12
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 4
  mul y x
  add z y
  inp w
  mul x 0
  add x z
  mod x 26
  div z 26
  add x -13
  eql x w
  eql x 0
  mul y 0
  add y 25
  mul y x
  add y 1
  mul z y
  mul y 0
  add y w
  add y 11
  mul y x
  add z y
  """

end