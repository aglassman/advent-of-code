defmodule LaunchModule do
  defstruct mass: nil

  import String

  def new(string) do
    %LaunchModule{
      mass: string |> trim() |> to_integer()
    }
  end

  def required_fuel(%LaunchModule{mass: mass}), do: calculate_fuel(mass)

  def calculate_fuel(mass) do
    fuel_mass = trunc(mass / 3.0) - 2

    if fuel_mass >= 0 do
      fuel_mass + calculate_fuel(fuel_mass)
    else
      0
    end
  end
end
