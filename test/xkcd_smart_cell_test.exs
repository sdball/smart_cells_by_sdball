defmodule ExDuckSmartCellTest do
  use ExUnit.Case, async: true

  import Kino.Test

  setup :configure_livebook_bridge

  test "initial source uses the defaults" do
    {_kino, source} = start_smart_cell!(XkcdSmartCell, %{})
    assert source == "Xkcd.number(nil) |> XkcdSmartCell.render_markdown()"
  end

  test "comic by number" do
    {_kino, source} = start_smart_cell!(XkcdSmartCell, %{"number" => 1270})
    assert source == "Xkcd.number(1270) |> XkcdSmartCell.render_markdown()"
  end
end
