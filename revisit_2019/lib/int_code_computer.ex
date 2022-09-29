defmodule IntCodeComputer do
  def new(code, input \\ [])

  def new(str_code, input) when is_binary(str_code) do
    str_code
    |> String.split(",")
    |> then(&new(&1, input))
  end

  def new(codes, input) do
    base = %{name: nil, on_halt: nil, input: input, output: [], ip: 0}
    for {code_str, index} <- Enum.with_index(codes), into: base do
      {index, String.to_integer(code_str)}
    end
  end

  def next_instruction(%{ip: ip} = state) do
    state
    |> Map.get(ip)
    |> parse_instruction()
  end

  def parse_instruction(integer) do
    instruction = rem(integer, 100)
    opcode_str = to_string(trunc(integer / 100))
    to_instruction(instruction, opcode_str)
  end

  def to_opcodes(string, pad) do
    string
    |> String.pad_leading(pad, "0")
    |> String.graphemes()
    |> Enum.reverse()
  end

  def to_instruction(99, _), do: :halt

  def to_instruction(1, opcode_str) do
    [:add | to_opcodes(opcode_str, 3)]
  end

  def to_instruction(2, opcode_str) do
    [:multiply | to_opcodes(opcode_str, 3)]
  end

  def to_instruction(3, opcode_str) do
    [:input | to_opcodes(opcode_str, 1)]
  end

  def to_instruction(4, opcode_str) do
    [:output | to_opcodes(opcode_str, 1)]
  end

  def to_instruction(5, opcode_str) do
    [:jump_if_true | to_opcodes(opcode_str, 2)]
  end

  def to_instruction(6, opcode_str) do
    [:jump_if_false | to_opcodes(opcode_str, 2)]
  end

  def to_instruction(7, opcode_str) do
    [:less_than | to_opcodes(opcode_str, 3)]
  end

  def to_instruction(8, opcode_str) do
    [:equals | to_opcodes(opcode_str, 3)]
  end

  def fetch_input(%{name: name, input: []} = state) do
    IO.inspect("program: #{name}, pid: #{inspect(self())} waiting for input")
    receive do
        input ->
          IO.inspect("pid: #{inspect(self())} received #{input}")
          {input, state}
    end
  end

  def fetch_input(state) do
    {[input | _], state} = Map.get_and_update(state, :input, fn input -> {input, tl(input)} end)
    {input, state}
  end

  def output(%{output_pid: pid, name: name} = state, output) do
    IO.inspect("program: #{name}, pid: #{inspect(pid)} sending #{output}")
    send(pid, output)
    Map.update(state, :output, [], fn outputs -> [output | outputs] end)
  end

  def output(state, output) do
    Map.update(state, :output, [], fn outputs -> [output | outputs] end)
  end

  def params(%{ip: ip} = state, num) do
    for i <- 1..num, into: [] do
      Map.get(state, ip + i)
    end
  end

  def lookup(state, location, "0") do
    Map.get(state, location)
  end

  def lookup(_state, value, "1") do
    value
  end

  def inc_ip(state, {:set, i}), do: %{state | ip: i}
  def inc_ip(state, i), do: %{state | ip: state[:ip] + i}

  def wait_for_link(state) do
    receive do
      {:link, %{name: name}, output_pid} ->
        IO.inspect("#{state.name} will output to #{name} ")
        state
        |> Map.put(:output_pid, output_pid)
        |> execute()
    end
  end

  def execute(state) do
    state
    |> next_instruction()
    |> execute(state)
  end

  def execute(:halt, %{on_halt: nil} = state) do
    IO.inspect("halting")
    state
  end

  def execute(:halt, %{on_halt: pid} = state) do
    IO.inspect("halting ?")
    send(pid, {:halt, state})
    state
  end

  def execute([:add, o1, o2, _], state) do
    [p1, p2, location] = params(state, 3)
    a = lookup(state, p1, o1)
    b = lookup(state, p2, o2)

    state
    |> Map.put(location, a + b)
    |> inc_ip(4)
    |> execute()
  end

  def execute([:multiply, o1, o2, _], state) do
    [p1, p2, location] = params(state, 3)
    a = lookup(state, p1, o1)
    b = lookup(state, p2, o2)

    state
    |> Map.put(location, a * b)
    |> inc_ip(4)
    |> execute()
  end

  def execute([:input, _], state) do
    [location] = params(state, 1)
    {input, state} = fetch_input(state)

    state
    |> Map.put(location, input)
    |> inc_ip(2)
    |> execute()
  end

  def execute([:output, o1], state) do
    [p1] = params(state, 1)
    val = lookup(state, p1, o1)

    state
    |> output(val)
    |> inc_ip(2)
    |> execute()
  end

  def execute([:jump_if_true, o1, o2], state) do
    [p1, p2] = params(state, 2)
    a = lookup(state, p1, o1)
    b = lookup(state, p2, o2)

    state
    |> inc_ip(
      if a != 0 do
        {:set, b}
      else
        3
      end
    )
    |> execute()
  end

  def execute([:jump_if_false, o1, o2], state) do
    [p1, p2] = params(state, 2)
    a = lookup(state, p1, o1)
    b = lookup(state, p2, o2)

    state
    |> inc_ip(
      if a == 0 do
        {:set, b}
      else
        3
      end
    )
    |> execute()
  end

  def execute([:less_than, o1, o2, _], state) do
    [p1, p2, location] = params(state, 3)
    a = lookup(state, p1, o1)
    b = lookup(state, p2, o2)

    state
    |> Map.put(
      location,
      if a < b do
        1
      else
        0
      end
    )
    |> inc_ip(4)
    |> execute()
  end

  def execute([:equals, o1, o2, _], state) do
    [p1, p2, location] = params(state, 3)
    a = lookup(state, p1, o1)
    b = lookup(state, p2, o2)

    state
    |> Map.put(
      location,
      if a == b do
        1
      else
        0
      end
    )
    |> inc_ip(4)
    |> execute()
  end
end
