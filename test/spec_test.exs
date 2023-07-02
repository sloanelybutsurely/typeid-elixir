defmodule TypeID.SpecTest do
  use ExUnit.Case

  @valid_specs :code.priv_dir(:typeid_elixir)
               |> Path.join("spec/valid.yml")
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

  # describe "invalid" do
  # end
end
