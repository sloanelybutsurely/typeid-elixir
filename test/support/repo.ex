defmodule TypeID.Repo do
  use Ecto.Repo,
    otp_app: :typeid_elixir,
    adapter: Ecto.Adapters.Postgres
end
