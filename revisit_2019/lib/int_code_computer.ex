defmodule IntCodeComputer do
  def new(codes) do
    for {code_str, index} <- Enum.with_index(codes), into: %{} do
      {index, String.to_integer(code_str)}
    end
  end

  # halt
  def execute(99, state, _ip), do: state

  # add
  def execute(1, state, ip) do
    loc = val_at(state, ip + 3)
    a = val_at(state, val_at(state, ip + 1))
    b = val_at(state, val_at(state, ip + 2))
    c = a + b
    state = Map.put(state, loc, c)
    #    IO.inspect("ADD: (#{a} + #{b} = #{c} -> #{loc})")
    execute(state, ip + 4)
  end

  # multiply
  def execute(2, state, ip) do
    loc = val_at(state, ip + 3)
    a = val_at(state, val_at(state, ip + 1))
    b = val_at(state, val_at(state, ip + 2))
    c = a * b
    state = Map.put(state, loc, c)
    #    IO.inspect("MULTIPLY: (#{a} * #{b} = #{c} -> #{loc})")
    execute(state, ip + 4)
  end

  def execute(state, ip \\ 0) do
    #    IO.inspect([state, ip])
    execute(Map.get(state, ip), state, ip)
  end

  def val_at(state, loc) do
    Map.get(state, loc)
  end
end
