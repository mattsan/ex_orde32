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

    inspect source_rects
  end

  defp string_rect(s) do
    [left, top, right, bottom] =
      s
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1, 36))

    %{left: left, top: top, right: right, bottom: bottom}
  end
end
