defmodule Wires do
  @spec new({string :: String.t(), wire_id :: integer()}) ::
          {wire_id :: integer(), [{direction :: String.t(), steps :: integer()}]}
  def new({string, wire_id}) do
    wire =
      string
      |> String.trim()
      |> String.split(",")
      |> Enum.map(fn <<direction::binary-size(1), steps::binary>> ->
        {direction, String.to_integer(steps)}
      end)

    {wire_id, wire}
  end

  # map key is the location %{x: x, y: y}, value is set of wire ids
  @spec plot(wire :: tuple(), plot :: map()) :: map()
  def plot({wire_id, wire}, plot) do
    plot = Map.put(plot, :current, %{x: 0, y: 0})

    {_, _, plot} =
      Enum.reduce(
        wire,
        {0, wire_id, plot},
        &plot_wire/2
      )

    plot
  end

  def plot_wire({direction, steps}, {wire_length, wire_id, plot}) do
    scalar =
      case direction do
        "U" -> {0, 1}
        "D" -> {0, -1}
        "L" -> {-1, 0}
        "R" -> {1, 0}
      end

    {_, _, _, plot} =
      Enum.reduce(0..(steps - 1), {wire_length, scalar, wire_id, plot}, &plot_segment/2)

    {wire_length + steps, wire_id, plot}
  end

  def plot_segment(
        step,
        {wire_length, {sx, sy} = scalar, wire_id, %{current: %{x: cx, y: cy} = current} = plot}
      ) do
    wire_segment = {wire_id, wire_length + step}

    plot =
      plot
      |> Map.put(:current, %{x: cx + 1 * sx, y: cy + 1 * sy})
      |> Map.update(current, [wire_segment], fn wire_segments ->
        if match?([{^wire_id, _}], wire_segments) do
          wire_segments
        else
          [wire_segment | wire_segments]
        end
      end)

    plot =
      case Map.get(plot, current) do
        [{a, a_length}, {b, b_length}] ->
          intersection = {a, b, current, a_length + b_length}

          Map.update(plot, :intersections, [intersection], fn intersections ->
            [intersection | intersections]
          end)

        _ ->
          plot
      end

    {wire_length, scalar, wire_id, plot}
  end
end
