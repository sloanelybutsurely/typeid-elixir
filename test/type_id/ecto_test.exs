defmodule TypeID.EctoTest do
  use TypeID.DataCase, async: true

  describe "belongs_to relationships" do
    defmodule Post do
      use Ecto.Schema

      @primary_key {:id, TypeID, autogenerate: true, prefix: "post", type: :uuid}
      @foreign_key_type TypeID
      schema "posts" do
        field :content
        has_many :comments, TypeID.EctoTest.Comment
      end
    end

    defmodule Comment do
      use Ecto.Schema

      @primary_key {:id, TypeID, autogenerate: true, prefix: "post", type: :uuid}
      @foreign_key_type TypeID
      schema "comments" do
        field :content
        belongs_to :post, TypeID.EctoTest.Post
      end
    end

    test "infers the database type for a belongs_to relationship" do
      post_changeset = Ecto.Changeset.change(%Post{}, %{content: "Hello, World!"})
      assert {:ok, post} = TypeID.Repo.insert(post_changeset)

      comment_changeset =
        post
        |> Ecto.build_assoc(:comments)
        |> Ecto.Changeset.change(%{content: "Great post!"})

      assert {:ok, comment} = TypeID.Repo.insert(comment_changeset)
    end
  end
end
