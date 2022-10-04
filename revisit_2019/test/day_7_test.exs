defmodule Day07Test do
  use ExUnit.Case

  import IntCodeComputer

  test "part 1" do
    program = new(code)

    trials =
      for a <- 0..4,
          b <- 0..4,
          c <- 0..4,
          d <- 0..4,
          e <- 0..4,
          [a, b, c, d, e] |> Enum.uniq() |> length() == 5 do
        prog_a = %{program | name: "a", input: [a, 0]}
        prog_b = %{program | name: "b", input: [b]}
        prog_c = %{program | name: "c", input: [c]}
        prog_d = %{program | name: "d", input: [d]}
        prog_e = %{program | name: "e", on_halt: self(), input: [e]}

        pid_a = spawn(fn -> wait_for_link(prog_a) end)
        pid_b = spawn(fn -> wait_for_link(prog_b) end)
        pid_c = spawn(fn -> wait_for_link(prog_c) end)
        pid_d = spawn(fn -> wait_for_link(prog_d) end)
        pid_e = spawn(fn -> wait_for_link(prog_e) end)

        send(pid_a, {:link, prog_b, pid_b})
        send(pid_b, {:link, prog_c, pid_c})
        send(pid_c, {:link, prog_d, pid_d})
        send(pid_d, {:link, prog_e, pid_e})
        send(pid_e, {:link, prog_a, pid_a})

        receive do
          {:halt, %{output: [output | _]}} ->
            output
        end
      end

    answer = Enum.max(trials)

    assert 277_328 == answer
  end

  test "part 2 example" do
    program =
      new("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")

    [a, b, c, d, e] = [9, 8, 7, 6, 5]
    prog_a = %{program | name: "a", input: [a, 0]}
    prog_b = %{program | name: "b", input: [b]}
    prog_c = %{program | name: "c", input: [c]}
    prog_d = %{program | name: "d", input: [d]}
    prog_e = %{program | name: "e", on_halt: self(), input: [e]}

    pid_a = spawn(fn -> wait_for_link(prog_a) end)
    pid_b = spawn(fn -> wait_for_link(prog_b) end)
    pid_c = spawn(fn -> wait_for_link(prog_c) end)
    pid_d = spawn(fn -> wait_for_link(prog_d) end)
    pid_e = spawn(fn -> wait_for_link(prog_e) end)

    send(pid_a, {:link, prog_e, pid_e})
    send(pid_b, {:link, prog_a, pid_a})
    send(pid_c, {:link, prog_b, pid_b})
    send(pid_d, {:link, prog_c, pid_c})
    send(pid_e, {:link, prog_d, pid_d})

    output =
      receive do
        {:halt, %{output: [output | _]}} ->
          output
      end

    assert 139_629_729 == output
  end

  test "part 2" do
    program = new(code)

    trials =
      for a <- 5..9,
          b <- 5..9,
          c <- 5..9,
          d <- 5..9,
          e <- 5..9,
          [a, b, c, d, e] |> Enum.uniq() |> length() == 5 do
        prog_a = %{program | name: "a", input: [a, 0]}
        prog_b = %{program | name: "b", input: [b]}
        prog_c = %{program | name: "c", input: [c]}
        prog_d = %{program | name: "d", input: [d]}
        prog_e = %{program | name: "e", on_halt: self(), input: [e]}

        pid_a = spawn(fn -> wait_for_link(prog_a) end)
        pid_b = spawn(fn -> wait_for_link(prog_b) end)
        pid_c = spawn(fn -> wait_for_link(prog_c) end)
        pid_d = spawn(fn -> wait_for_link(prog_d) end)
        pid_e = spawn(fn -> wait_for_link(prog_e) end)

        send(pid_a, {:link, prog_b, pid_b})
        send(pid_b, {:link, prog_c, pid_c})
        send(pid_c, {:link, prog_d, pid_d})
        send(pid_d, {:link, prog_e, pid_e})
        send(pid_e, {:link, prog_a, pid_a})

        receive do
          {:halt, %{output: [output | _]}} ->
            output
        end
      end

    answer = Enum.max(trials)

    assert 277_328 == answer
  end

  def code(),
    do:
      "3,8,1001,8,10,8,105,1,0,0,21,38,55,68,93,118,199,280,361,442,99999,3,9,1002,9,2,9,101,5,9,9,102,4,9,9,4,9,99,3,9,101,3,9,9,1002,9,3,9,1001,9,4,9,4,9,99,3,9,101,4,9,9,102,3,9,9,4,9,99,3,9,102,2,9,9,101,4,9,9,102,2,9,9,1001,9,4,9,102,4,9,9,4,9,99,3,9,1002,9,2,9,1001,9,2,9,1002,9,5,9,1001,9,2,9,1002,9,4,9,4,9,99,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99"
end
