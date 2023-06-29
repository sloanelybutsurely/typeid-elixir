defmodule TypeIDTest do
  use ExUnit.Case

  describe "new/1" do
    test "returns a new TypeID struct" do
      tid = TypeID.new("test")
      assert is_struct(tid, TypeID)
      assert "test" == TypeID.type(tid)
    end
  end

  describe "type/1" do
    test "returns the type (prefix) of the given TypeID" do
      tid = TypeID.from_string!("test_01h44had5rfswbvpc383ktj0aa")
      assert "test" == TypeID.type(tid)
    end
  end

  describe "suffix/1" do
    test "returns the base 32 suffix of the given TypeID" do
      tid = TypeID.from_string!("test_01h44had5rfswbvpc383ktj0aa")
      assert "01h44had5rfswbvpc383ktj0aa" == TypeID.suffix(tid)
    end
  end

  describe "serialization" do
    test "to_string/1 and from_string!/1 are idempotent" do
      tid1 = TypeID.from_string!("test_01h44had5rfswbvpc383ktj0aa")
      tid2 =
        tid1
        |> TypeID.to_string()
        |> TypeID.from_string!()
      assert tid1 == tid2
    end
  end

end
