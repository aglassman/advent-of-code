defmodule Day16Test do
  use ExUnit.Case

  test "example 1" do
    assert [{:header, :literal, 6, 4, {:literal, 2021}}, <<0::size(3)>>] ==
             "D2FE28"
             |> parse_input()
             |> parse()
  end

  test "example 1.1" do
    assert [{:header, :operator, 1, 6, {:length, 27, [{:header, :literal, 6, 4, {:literal, 10}}, {{:header, :literal, 2, 4, {:literal, 20}}, ""}]}}, :end]
           ==
             "38006F45291200"
             |> parse_input()
             |> parse()
  end

  test "example 1.2" do
    assert  [{:header, :operator, 4, 2, {:literal, 1}}, {{:header, :operator, 1, 2, {:literal, 1}}, <<168, 0, 47, 71, 8::size(4)>>}] ==
             "8A004A801A8002F478"
             |> parse_input()
             |> parse()
  end

  test "day 16 - part 1" do
    assert 0 ==
             File.read!("input/16.txt")
             |> parse_input()
             |> parse()
             |> IO.inspect()
  end

  test "example 2" do
    assert 0 ==
             File.read!("input/16.txt")
             |> parse_input()
  end

  test "day 16 - part 2" do
    assert 0 ==
             File.read!("input/16.txt")
             |> parse_input()
  end

  def parse_input(input) do
    Base.decode16!(input)
  end

  def parse(input, output \\ []) do
    case header(input) do
      :end ->
        output

      {parsed, remaining} ->
        output ++ [parsed, header(remaining)]
    end
  end

  def header(<<version::3, type::3, rest::bitstring>>) do
    packet =
      case {version, type} do
        {0, 0} ->
          :end

        {_, 4} ->
          {parsed, remaining} = literal_value(rest, <<>>)
          {{:header, :literal, version, type, parsed}, remaining}

        {_, _} ->
          {parsed, remaining} = operator(rest)
          {{:header, :operator, version, type, parsed}, remaining}
      end
  rescue
    error ->
      :end
  end

  def header(input) do
    input
  end

  def literal_value(<<1::1, number::4, rest::bitstring>>, acc) do
    literal_value(rest, <<acc::bitstring, number::4>>)
  end

  def literal_value(<<0::1, number::4, rest::bitstring>>, acc) do
    val = <<acc::bitstring, number::4>>
    val_size = bit_size(val)
    <<num::integer-size(val_size)>> = val
    {{:literal, num}, rest}
  end

  def operator(<<1::1, number::11, rest::bitstring>>) do
    {{:literal, number}, rest}
  end

  def operator(<<0::1, len::15, subpackets::bitstring-size(len), rest::bitstring>>) do
    {{:length, len, parse(subpackets)}, rest}
  end

  def operator(_), do: :end
end
