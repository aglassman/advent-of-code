defmodule Day08Test do
  use ExUnit.Case

  @example """
  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6
  """

  test "example - part 1" do
    assert {:early, 5} = run(parse_to_bootcode(@example))
  end

  test "day 8 - part 1" do
    assert {:early, 1727} = run(parse_to_bootcode(File.read!("input/8.txt")))
  end

  test "example - part 2" do
    assert {:complete, 8} = run_to_completion(parse_to_bootcode(@example))
  end

  test "day 8 - part 2" do
    assert {:complete, 552} = run_to_completion(parse_to_bootcode(File.read!("input/8.txt")))
  end

  def parse_to_bootcode(input) do
    String.split(input, "\n", trim: true)
    |> Stream.with_index()
    |> Stream.map(fn {<<op::binary-size(3)>> <> " " <> val, i} ->
      {i, {op, String.to_integer(val), 0}}
    end)
    |> Enum.into(%{})
  end

  def run_to_completion(bootcode) do
    bootcode
    |> Stream.map(fn
      {i, {"nop", val, _}} -> {i, {"jmp", val, 0}}
      {i, {"jmp", val, _}} -> {i, {"nop", val, 0}}
      _ -> nil
    end)
    |> Stream.reject(&is_nil/1)
    |> Enum.find_value(fn {i, modified} ->
      case run(Map.put(bootcode, i, modified)) do
        {:early, _} -> nil
        complete -> complete
      end
    end)
  end

  def run(bootcode, pointer \\ 0, acc \\ 0) do
    case Map.get(bootcode, pointer) do
      {"acc", val, 0} -> bootcode |> inc(pointer) |> run(pointer + 1, acc + val)
      {"jmp", val, 0} -> bootcode |> inc(pointer) |> run(pointer + val, acc)
      {"nop", _, 0} -> bootcode |> inc(pointer) |> run(pointer + 1, acc)
      {_, _, 1} -> {:early, acc}
      nil -> {:complete, acc}
    end
  end

  def inc(bootcode, pointer), do: Map.update!(bootcode, pointer, &put_elem(&1, 2, 1))
end
