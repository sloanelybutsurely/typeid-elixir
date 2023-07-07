defmodule TypeID.JasonEncoderTest do
  use ExUnit.Case, async: true

  defmodule User do
    @derive Jason.Encoder
    defstruct [:id, :name]
  end

  alias __MODULE__.User

  test "structs with TypeID values can be encoded to JSON" do
    assert {:ok, id} = TypeID.from_string("user_01h4rse40gf60a3kz9tkmsws17")

    user = %User{id: id, name: "Sloane"}

    assert {:ok, ~S|{"id":"user_01h4rse40gf60a3kz9tkmsws17","name":"Sloane"}|} =
             Jason.encode(user)
  end
end
