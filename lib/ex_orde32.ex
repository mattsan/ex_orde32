defmodule ExOrde32 do
  @moduledoc """
  Documentation for ExOrde32.
  """

  def solve(input) do
    source_rects =
      input
      |> String.split("/", trim: true)
      |> Enum.map(&string_rect/1)

    source_count = Enum.count(source_rects)

    result_cells =
      Enum.reduce(0..35, %{}, fn x, cells ->
        Enum.reduce(0..35, cells, fn y, cells2 ->
          value =
            (0..source_count-1)
            |> Enum.filter(fn i ->
              rect = Enum.at(source_rects, i)
              rect.left <= x && x < rect.right && rect.top <= y && y < rect.bottom
            end)
          Map.put(cells2, {x, y}, value)
        end)
      end)

    result_cells
    |> Map.values()
    |> Enum.uniq()
    |> Enum.filter(&Enum.count(&1) > 0)
    |> Enum.map(&calc_rect_size(result_cells, &1))
    |> List.flatten()
    |> Enum.filter(&(&1 > 0))
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp string_rect(s) do
    [left, top, right, bottom] =
      s
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1, 36))

    %{left: left, top: top, right: right, bottom: bottom}
  end

  defp calc_rect_size(cells, value) do
    target_cells = for x <- (0..35), y <- (0..35), Map.get(cells, {x, y}) == value, do: {x, y}

    chunk_connected(target_cells)
    |> Enum.map(fn chunk ->
      chunk_count = Enum.count(chunk)

      {left, right} = chunk |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
      {top, bottom} = chunk |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

      if (right - left + 1) * (bottom - top + 1) == chunk_count do
        chunk_count
      else
        0
      end
    end)
  end

  def chunk_connected(cells) do
    chunk_connected(cells, [])

    # 実装中
    [cells]
  end

  def chunk_connected([], chunks) do
    chunks
  end

  def chunk_connected([{x, y} | cells], chunks) do
    next_chunks =
      chunks
      |> Enum.map(fn chunk ->
        if Enum.count(for dx <- x-1..x+1, dy <- y-1..y+1, Enum.find(chunk, fn {cx, cy} -> cx == dx && cy == dy end), do: 1) > 0 do
          chunk
        else
          [{x, y} | chunk]
        end
      end)

    if next_chunks == chunks do
      chunk_connected(cells, [[{x, y}] | chunks])
    else
      chunk_connected(cells, next_chunks)
    end
  end
end
