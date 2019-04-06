defmodule ExOrde32Test do
  use ExUnit.Case
  doctest ExOrde32

  import ExOrde32

  test "T", do: assert solve("abc") == "abc"
  test "F", do: assert solve("abc") == "ABC"
end
