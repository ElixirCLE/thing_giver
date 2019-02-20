defmodule ThingGiver.Gifts.Gift do
  use Ecto.Schema
  import Ecto.Changeset


  schema "gifts" do
    field :giver, :string
    field :receiver, :string
    field :thing, :string
    field :verb, :string

    timestamps()
  end

  @doc false
  def changeset(gift, attrs) do
    gift
    |> cast(attrs, [:giver, :receiver, :verb, :thing])
    |> validate_required([:giver, :receiver, :verb, :thing])
  end
end
