import AOC

aoc 2022, 7 do
  def p1(input) do
    input
    |> parse_commands()
    |> infer_filesystem()
    |> directory_sizes()
    |> Enum.reduce(0, fn
      {_path, size}, acc when size <= 100_000 -> acc + size
      _, acc -> acc
    end)
  end

  def p2(input) do
    folder_sizes = input
    |> parse_commands()
    |> infer_filesystem()
    |> directory_sizes()
    |> Enum.sort_by(fn {path, size} -> -size end)

    [{_, root_size} | _] = folder_sizes
    remaining_space = 70_000_000 - root_size
    to_delete = 30000000 - remaining_space

    Enum.reduce_while(folder_sizes, 0, fn {path, size}, acc ->
      if size < to_delete do
        {:halt, acc}
      else
        {:cont, size}
      end
    end)

  end

  def parse_commands(input) do
    input
    |> String.split("\n")
  end

  def infer_filesystem(filesystem, []), do: Map.drop(filesystem, [:current])

  def infer_filesystem(filesystem \\ %{}, [command | commands]) do
    command
    |> case do
      "$ cd .." ->
        Map.update(filesystem, :current, [], fn [_ | path] -> path end)
      "$ cd " <> folder ->
        filesystem = Map.update(filesystem, :current, [folder], fn path -> [folder | path] end)
        filesystem = Map.put(filesystem, filesystem[:current], [])
      "dir " <> folder ->
        Map.update(filesystem, filesystem[:current], [], fn contents -> [folder | contents] end)
      "$ ls" ->
        filesystem
      file ->
        [size_str, name] = String.split(file)
        file = {String.to_integer(size_str), name}
        filesystem
        Map.update(filesystem, filesystem[:current], [], fn contents -> [file | contents] end)
    end
    |> infer_filesystem(commands)
  end

  def directory_sizes(filesystem, current \\ ["/"], sizes \\ %{}) do
    {size, sizes} = Enum.reduce(filesystem[current], {0, sizes}, fn
      {size, _}, {acc, sizes} ->
        {acc + size, sizes}
      folder, {acc, sizes} ->
        sizes = directory_sizes(filesystem, [folder | current], sizes)
        {acc + (sizes[[folder | current]] || 0), sizes}
    end)
    Map.put(sizes, current, size)
  end

end
