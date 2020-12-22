defmodule Day21Test do
  use ExUnit.Case

  @example """
  mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
  trh fvjkl sbzzf mxmxvkd (contains dairy)
  sqjhc fvjkl (contains soy)
  sqjhc mxmxvkd sbzzf (contains fish)
  """

  import String
  import Enum

  test "example - part 1" do
    assert 5 ==
             @example
             |> foods()
             |> part_1()
  end

  test "day 21 - part 1" do
    assert 1679 ==
             "input/21.txt"
             |> File.read!()
             |> foods()
             |> part_1()
  end

  test "day 21 - part 2" do
    assert "lmxt,rggkbpj,mxf,gpxmf,nmtzlj,dlkxsxg,fvqg,dxzq" ==
             "input/21.txt"
             |> File.read!()
             |> foods()
             |> part_2()
  end

  def part_1({{ingredient_set, allergen_set}, foods} = parsed_foods) do
    identified_allergens =
      identify_allergens(parsed_foods)
      |> map(&elem(&1, 1))
      |> reduce(&MapSet.union/2)

    allergen_free_ingredients = MapSet.difference(ingredient_set, identified_allergens)

    reduce(foods, 0, fn {ingredients, _}, count ->
      count + (MapSet.intersection(ingredients, allergen_free_ingredients) |> MapSet.size())
    end)
  end

  def part_2(parsed_foods) do
    identify_allergens(parsed_foods)
    |> sort_by(fn {allergen, _} -> allergen end)
    |> flat_map(fn {_, identified} -> MapSet.to_list(identified) end)
    |> join(",")
  end

  def identify_allergens({{ingredient_set, allergen_set}, foods}) do
    potential_allergens =
      ingredient_set
      |> MapSet.to_list()
      |> map(fn ingredient -> {ingredient, ingredient_to_allergens(foods, ingredient)} end)

    potential_ingredients =
      allergen_set
      |> MapSet.to_list()
      |> map(fn allergen -> {allergen, allergen_to_ingredients(foods, allergen)} end)

    allergen_candidates =
      for allergen <- MapSet.to_list(allergen_set) do
        candidates =
          foods
          |> filter(fn {f, a} -> MapSet.member?(a, allergen) end)
          |> map(&elem(&1, 0))
          |> reduce(&MapSet.intersection/2)

        {allergen, candidates}
      end

    resolve_candidates(allergen_candidates)
  end

  def resolve_candidates(allergen_candidates, identified \\ %{}) do
    {allergen, candidates} =
      allergen_candidates
      |> min_by(fn {_, candidates} -> MapSet.size(candidates) end)

    identified = Map.put(identified, allergen, candidates)

    allergen_candidates =
      allergen_candidates
      |> reject(fn {a, _} -> a == allergen end)
      |> map(fn {a, c} -> {a, MapSet.difference(c, candidates)} end)

    if count(allergen_candidates) == 0 do
      identified
    else
      resolve_candidates(allergen_candidates, identified)
    end
  end

  def ingredient_to_allergens(foods, ingredient) do
    foods
    |> filter(fn {ingredient_set, allergen_set} ->
      MapSet.member?(ingredient_set, ingredient)
    end)
    |> map(fn {ingredient_set, allergen_set} -> allergen_set end)
    |> reduce(MapSet.new(), &MapSet.union/2)
  end

  def allergen_to_ingredients(foods, allergen) do
    foods
    |> filter(fn {ingredient_set, allergen_set} ->
      MapSet.member?(allergen_set, allergen)
    end)
    |> map(fn {ingredient_set, allergen_set} -> ingredient_set end)
    |> reduce(MapSet.new(), &MapSet.union/2)
  end

  def foods(input) do
    food_list =
      input
      |> split("\n", trim: true)
      |> map(&split(&1, "(", trim: true))
      |> map(fn [ingredients, allergens] ->
        {
          ingredients
          |> split(" ", trim: true)
          |> MapSet.new(),
          allergens
          |> trim_trailing(")")
          |> split(", ", trim: true)
          |> map(&trim_leading(&1, "contains "))
          |> MapSet.new()
        }
      end)

    uniques =
      food_list
      |> reduce({MapSet.new(), MapSet.new()}, fn {foods, allergens}, {food_set, allergen_set} ->
        {MapSet.union(food_set, MapSet.new(foods)),
         MapSet.union(allergen_set, MapSet.new(allergens))}
      end)

    {uniques, food_list}
  end
end
