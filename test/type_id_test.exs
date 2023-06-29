defmodule TypeIDTest do
  use ExUnit.Case

  describe "new/1" do
    test "returns a new TypeID struct" do
      tid = TypeID.new("test")
      assert is_struct(tid, TypeID)
    end
  end

  describe "from_string!/1" do
    test "parses TypeIDs as defined by the spec" do
      tid = TypeID.from_string!("test_01h44had5rfswbvpc383ktj0aa")
      assert "test" == TypeID.type(tid)
      assert "01890915-34b8-7e78-bdd9-8340e7a9014a" == TypeID.uuid(tid)
    end
  end

end
