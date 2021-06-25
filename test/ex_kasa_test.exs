defmodule ExKasaTest do
  use ExUnit.Case
  doctest ExKasa

  test "greets the world" do
    assert ExKasa.hello() == :world
  end
end
