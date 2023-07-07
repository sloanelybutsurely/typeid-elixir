defmodule TypeID.StringCharTest do
  use ExUnit.Case, async: true

  test "implicit cast to string" do
    assert {:ok, tid} = TypeID.from_string("test_01h4rm6n03esc96rwqtnq2fr5a")
    assert "cast? test_01h4rm6n03esc96rwqtnq2fr5a" == "cast? #{tid}"
  end

  test "Kernel.to_string/1" do
    assert {:ok, tid} = TypeID.from_string("test_01h4rm6n03esc96rwqtnq2fr5a")
    assert "test_01h4rm6n03esc96rwqtnq2fr5a" == to_string(tid)
  end
end
