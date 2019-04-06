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

    target_cell_count = Enum.count(target_cells)

    {left, right} = target_cells |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {top, bottom} = target_cells |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    if (right - left + 1) * (bottom - top + 1) == target_cell_count do
      target_cell_count
    else
      0
    end
  end
end
