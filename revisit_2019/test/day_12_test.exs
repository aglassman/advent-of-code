defmodule Day11Test do
  use ExUnit.Case


  test "part 1" do
    start = input()

    total_e = start
    |> simulate(1000)
    |> total_energy()


    assert 0 == total_e
  end

  def total_energy(state) do

  end

  def simulate(state, 0), do: state

  def simulate(state, i) do
    for p1 <- state, p2 <- state, :distinct do

    end
  end


  @zero_v {0, 0 ,0}

  @input %{
    a: {{19, -10, 7},  @zero_v},
    b: {{1, 2, -3},  @zero_v},
    c: {{14, -4, 1},  @zero_v},
    d: {{8, 7, -6},  @zero_v},
  }

  @pairs [
    a: :b,
    a: :c,
    a: :d,
    b: :c,
    b: :d,
    c: :d
  ]

end