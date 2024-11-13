import Config

config :typeid_elixir, ecto_repos: [TypeID.Repo]

config :typeid_elixir, TypeID.Repo,
  database: "type_id_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
