defmodule ExDuckSmartCellTest do
  use ExUnit.Case, async: true

  import Kino.Test

  setup :configure_livebook_bridge

  test "initial source uses the defaults" do
    {_kino, source} = start_smart_cell!(XkcdSmartCell, %{})
    assert source
  end

  test "comic by number" do
    {_kino, source} = start_smart_cell!(XkcdSmartCell, %{"number" => 1270})
    assert String.contains?(source, "num: 1270")
  end
end
