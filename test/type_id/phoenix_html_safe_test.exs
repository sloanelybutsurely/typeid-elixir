defmodule TypeID.PhoenixHTMLSafeTest do
  use ExUnit.Case, async: true

  test "to_iodata/1" do
    assert {:ok, tid} = TypeID.from_string("test_01h4rm6n03esc96rwqtnq2fr5a")

    assert "test_01h4rm6n03esc96rwqtnq2fr5a" ==
             tid |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
  end

  test "no prefix" do
    assert {:ok, tid} = TypeID.from_string("01h4rm6n03esc96rwqtnq2fr5a")

    assert "01h4rm6n03esc96rwqtnq2fr5a" ==
             tid |> Phoenix.HTML.Safe.to_iodata() |> IO.iodata_to_binary()
  end
end
