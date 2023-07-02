defmodule TypeID.SpecTest do
  use ExUnit.Case

  specs_path = :code.priv_dir(:typeid_elixir)
               |> Path.join("/spec")

  @valid_specs specs_path
               |> Path.join("/valid.yml")
               |> YamlElixir.read_from_file!()

  @invalid_specs specs_path
               |> Path.join("/invalid.yml")
               |> YamlElixir.read_from_file!()

  describe "valid" do
    for %{"name" => name, "typeid" => typeid, "prefix" => prefix, "uuid" => uuid} <- @valid_specs do
      test "#{name}" do
        assert {:ok, tid} = TypeID.from_uuid(unquote(prefix), unquote(uuid))
        assert unquote(typeid) == TypeID.to_string(tid)
        assert {:ok, ^tid} = TypeID.from_string(unquote(typeid))
      end
    end
  end

  describe "invalid" do
    for %{"name" => name, "typeid" => typeid, "description" => desc } <- @invalid_specs do
      test "#{name}: #{desc}" do
        assert :error = TypeID.from_string(unquote(typeid))
      end
    end
  end
end
