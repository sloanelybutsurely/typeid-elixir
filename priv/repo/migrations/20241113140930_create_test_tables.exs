defmodule TypeID.Repo.Migrations.CreateTestTables do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content, :text
    end

    create table(:comments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :post_id, references(:posts, type: :uuid, on_delete: :delete_all)
      add :content, :text
    end

    create index(:comments, [:post_id], name: :comments_post_id_index)
  end
end
