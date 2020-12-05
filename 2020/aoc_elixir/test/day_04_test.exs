defmodule Day04Test do
  use ExUnit.Case

  @example """
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
  """

  @valid_passports """
  pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
  hcl:#623a2f

  eyr:2029 ecl:blu cid:129 byr:1989
  iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

  hcl:#888785
  hgt:164cm byr:2001 iyr:2015 cid:88
  pid:545766238 ecl:hzl
  eyr:2022

  iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  """

  @invalid_passports """
  eyr:1972 cid:100
  hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

  iyr:2019
  hcl:#602927 eyr:1967 hgt:170cm
  ecl:grn pid:012533040 byr:1946

  hcl:dab227 iyr:2012
  ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

  hgt:59cm ecl:zzz
  eyr:2038 hcl:74454a iyr:2023
  pid:3556412378 byr:2007
  """

  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  test "example - part 1" do
    assert 2 == parse_input(@example) |> count_valid()
  end

  test "day 4 - part 1" do
    assert 190 == parse_input(File.read!("input/4.txt")) |> count_valid()
  end

  test "example - part 2" do
    assert 0 == parse_input(@invalid_passports) |> count_valid(validate_fields: true)
    assert 4 == parse_input(@valid_passports) |> count_valid(validate_fields: true)
  end

  test "day 4 - part 2" do
    assert 121 == parse_input(File.read!("input/4.txt")) |> count_valid(validate_fields: true)
  end

  def parse_input(input) do
    input
    |> String.split("\n\n")
    |> Stream.map(&to_map/1)
  end

  def to_map(string) do
    Regex.scan(~r/.{3}:[^ \n]+/, string)
    |> Stream.map(fn [<<key::binary-size(3)>> <> ":" <> value] -> {key, value} end)
    |> Enum.into(%{})
  end

  def count_valid(passports, opts \\ []) do
    passports
    |> Stream.map(fn passport -> Map.take(passport, @required_fields) end)
    |> Stream.reject(fn passport ->
      Enum.count(Map.keys(passport)) != Enum.count(@required_fields)
    end)
    |> Stream.reject(fn passport ->
      Keyword.get(opts, :validate_fields, false) && !fields_valid?(passport)
    end)
    |> Enum.count()
  end

  def val_check(str_value, min, max) do
    int_val = String.to_integer(str_value)
    int_val >= min && int_val <= max
  end

  def fields_valid?(passport) do
    passport |> Enum.all?(&field_valid?/1)
  end

  def field_valid?({"byr", value}), do: val_check(value, 1920, 2002)

  def field_valid?({"iyr", value}), do: val_check(value, 2010, 2020)

  def field_valid?({"eyr", value}), do: val_check(value, 2020, 2030)

  def field_valid?({"hgt", value}) do
    case Regex.named_captures(~r/(?<height>[\d]+)(?<unit>in|cm)/, value) do
      %{"height" => h, "unit" => "in"} -> val_check(h, 59, 76)
      %{"height" => h, "unit" => "cm"} -> val_check(h, 150, 193)
      _ -> false
    end
  end

  def field_valid?({"hcl", "#" <> value}), do: Regex.match?(~r/^[0-9a-f]{6}$/, value)

  def field_valid?({"ecl", value}), do: value in ~W/amb blu brn gry grn hzl oth/

  def field_valid?({"pid", value}), do: Regex.match?(~r/^[0-9]{9}$/, value)

  def field_valid?(_), do: false
end
