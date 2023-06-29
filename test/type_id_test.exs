defmodule TypeIDTest do
  use ExUnit.Case

  describe "new/1" do
    test "returns a new TypeID struct" do
      tid = TypeID.new("test")
      assert is_struct(tid, TypeID)
    end
  end

end
