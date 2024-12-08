defmodule AocUtils do
  def grid(input) do
    map = input
          |> String.split("\n")
          |> Enum.map(&String.graphemes/1)
    [row | _] = map
    rows = length(map)
    columns = length(row)

    entries = for {row, r} <- Enum.with_index(map), {v, c} <- Enum.with_index(row) do
      {{c, r}, v}
    end

    {Map.new(entries), rows, columns}
  end
end