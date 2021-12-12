defmodule OMCTest do
  use ExUnit.Case
  doctest OMC

  test "greets the world" do
    assert OMC.hello() == :world
  end
end
