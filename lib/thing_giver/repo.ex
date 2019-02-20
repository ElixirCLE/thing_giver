defmodule ThingGiver.Repo do
  use Ecto.Repo,
    otp_app: :thing_giver,
    adapter: Ecto.Adapters.Postgres
end
