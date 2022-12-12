import AOC

aoc 2022, 11 do
  def p1(input) do
    monkeys = input
    |> parse()
    |> throw(20, &trunc(&1/3))
    |> Enum.map(fn {_, %{inspected: i}} -> i end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&*/2)
  end

  def p2(input) do
    monkeys = parse(input)

    primes_product = monkeys
    |> Enum.map(fn {_, %{div_by: div_by}} -> div_by end)
    |> Enum.reduce(&*/2)

    result = monkeys
    |> throw(10_000, &rem(&1, primes_product))
    |> Enum.map(fn {_, %{inspected: i}} -> i end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&*/2)

    result == 15693274740
  end

  def throw(monkeys, 0, _), do: monkeys

  def throw(monkeys, times, worry_calc) do
    monkeys = for id <- 0..(Map.size(monkeys) - 1), reduce: monkeys do
      monkeys ->
        throw_all(monkeys[id], monkeys, worry_calc)
    end
    throw(monkeys, times - 1, worry_calc)
  end

  def throw_all(%{items: []}, monkeys, _) do
    monkeys
  end

  def throw_all(%{id: id, items: [i | items]} = m, monkeys, worry_calc) do
    new_i = inspect_item(i, m)
    safe_i = worry_calc.(new_i)
    to_monkey_id = throw_to(new_i, m)
    to_monkey = monkeys[to_monkey_id]
    monkey = %{m | inspected: m[:inspected] + 1 , items: items}

    monkeys = monkeys
    |> Map.put(id, monkey)
    |> Map.put(to_monkey_id, %{to_monkey | items: to_monkey[:items] ++ [safe_i]})

    throw_all(monkey, monkeys, worry_calc)
  end


  def inspect_item(item, %{operation: op}), do: op.(item)

  def throw_to(i, %{test: test, true: mt, false: ft}) do
    case test.(i) do
      :true -> mt
      :false -> ft
    end
  end

  def parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.with_index()
    |> Enum.map(&parse_monkey/1)
    |> Map.new()
  end

  def parse_monkey({input, id}) do
    monkey = input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{id: id, inspected: 0, div_count: 0}, &parse_line/2)

    {id, monkey}
  end

  def parse_line("Starting items: " <> items, monkey) do
    starting_items = items
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)

    Map.put(monkey, :items, starting_items)
  end

  def parse_line("Operation: new = old + " <> val, monkey) do
    val = String.to_integer(val)
    Map.put(monkey, :operation, fn old -> old + val end)
  end

  def parse_line("Operation: new = old * old", monkey) do
    Map.put(monkey, :operation, fn old -> old * old end)
  end

  def parse_line("Operation: new = old * " <> val, monkey) do
    val = String.to_integer(val)
    Map.put(monkey, :operation, fn old -> old * val end)
  end

  def parse_line("Test: divisible by " <> val, monkey) do
    val = String.to_integer(val)
    monkey
    |> Map.put(:test, fn i -> rem(i, val) == 0 end)
    |> Map.put(:div_by, val)
  end

  def parse_line("If true: throw to monkey " <> monkey_id, monkey) do
    Map.put(monkey, :true, String.to_integer(monkey_id))
  end

  def parse_line("If false: throw to monkey " <> monkey_id, monkey) do
    Map.put(monkey, :false, String.to_integer(monkey_id))
  end

  def parse_line(_, monkey), do: monkey

  def print_items(%{id: id, items: items}), do: "Monkey #{id}: #{Enum.join(items, ", ")}"
  def print_items(%{} = monkeys), do: Enum.map(monkeys, fn {i, m} -> print_items(m) end)

  def print_inspected(monkey), do: "Monkey #{monkey[:id]} inspected items #{monkey[:inspected]} times."
end
