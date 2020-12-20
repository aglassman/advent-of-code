defmodule Day19Test do
  use ExUnit.Case

  @example """
  0: 1 2
  1: "a"
  2: 1 3 | 3 1
  3: "b"
  """

  @example_2 """
  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"
  """

  test "example - part 1" do
    rules = rules(@example)
    assert matches?("aba", rules)
    assert matches?("aba", rules)
  end

  test "example 2 - part 1" do
    rules = rules(@example_2)
    assert matches?("aaaabb", rules)
    assert matches?("aaabab", rules)
    refute matches?("aaaabbb", rules)
  end

  test "day 19 - part 1" do
    [rules_in, messages_in] = File.read!("input/19.txt") |> String.split("\n\n")

    rules = rules(rules_in)

    assert 139 =
             messages_in
             |> String.split("\n")
             |> Enum.filter(fn message -> matches?(message, rules) end)
             |> Enum.count()
  end

  test "day 19 - part 2" do
    [rules_in, messages_in] = File.read!("input/19.2.txt") |> String.split("\n\n")

    rules = rules(rules_in)

    assert 289 =
             messages_in
             |> String.split("\n")
             |> Enum.filter(fn message -> matches?(message, rules) end)
             |> Enum.count()
  end

  def matches?(message, rules) do
    message
    |> String.graphemes()
    |> matches?(rules, Map.get(rules, "0"))
  end

  def matches?(msg, rules, [rule_hd | to_match]) when is_map_key(rules, rule_hd) do
    case Map.get(rules, rule_hd) do
      [[_ | _] = x, [_ | _] = y] ->
        matches?(msg, rules, x ++ to_match) || matches?(msg, rules, y ++ to_match)

      x ->
        matches?(msg, rules, x ++ to_match)
    end
  end

  def matches?([_ | _], rules, []), do: false
  def matches?([], rules, []), do: true

  def matches?([hd | tail], rules, [hd | to_match]) do
    matches?(tail, rules, to_match)
  end

  def matches?(_, _, _), do: false

  def rules(input) do
    input
    |> String.replace("\"", "")
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, rules ->
      {rule_id, rule} = parse(line)
      Map.put(rules, rule_id, rule)
    end)
  end

  def parse(rule) do
    [rule_id, body] = String.split(rule, ": ")
    {rule_id, split(String.split(body, " | "))}
  end

  def split([a]) when a in ["a", "b"], do: [a]
  def split([a]), do: rule_list(a)
  def split([a, b]), do: [rule_list(a), rule_list(b)]

  def rule_list(rules) do
    rules
    |> String.split(" ")
    |> Enum.reject(&(&1 == ""))
  end
end
