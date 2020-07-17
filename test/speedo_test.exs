defmodule SpeedoTest do
  use ExUnit.Case
  doctest Speedo

  test "greets the world" do
    assert Speedo.hello() == :world
  end
end
