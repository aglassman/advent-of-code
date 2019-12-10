defmodule AocElixir1 do
  @moduledoc """
  Documentation for AocElixir1.
  """

  @doc """

  """
  def getModuleWeights(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&Integer.parse/1)
    |> Stream.map(&(elem(&1,0)))
  end

  @doc """

  """
  def fuel_weight(module_weight) do
    (div(module_weight,3)) - 2
  end

  @doc """

  """
  def fuel_weight_recursive(payload_weight) do
    case (div(payload_weight,3)) - 2 do
      x when x <=0 ->
        0
      x -> x + fuel_weight_recursive(x)
    end
  end

end
