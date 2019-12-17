defmodule AocDay7ElixirTest do
  use ExUnit.Case
  doctest AocElixir7

  test "return hello world" do
    assert "Hello World" == AocElixir7.helloWorld()
  end

end