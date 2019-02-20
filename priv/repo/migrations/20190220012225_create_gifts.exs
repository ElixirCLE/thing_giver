defmodule ThingGiver.Repo.Migrations.CreateGifts do
  use Ecto.Migration

  def change do
    create table(:gifts) do
      add :giver, :string
      add :receiver, :string
      add :verb, :string
      add :thing, :string

      timestamps()
    end

  end
end
