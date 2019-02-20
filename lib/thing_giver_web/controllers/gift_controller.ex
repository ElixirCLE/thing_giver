defmodule ThingGiverWeb.GiftController do
  use ThingGiverWeb, :controller

  alias ThingGiver.Gifts
  alias ThingGiver.Gifts.Gift

  def index(conn, _params) do
    gifts = Gifts.list_gifts()
    render(conn, "index.html", gifts: gifts)
  end

  def new(conn, _params) do
    changeset = Gifts.change_gift(%Gift{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"gift" => gift_params}) do
    case Gifts.create_gift(gift_params) do
      {:ok, gift} ->
        conn
        |> put_flash(:info, "Gift created successfully.")
        |> redirect(to: Routes.gift_path(conn, :show, gift))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gift = Gifts.get_gift!(id)
    render(conn, "show.html", gift: gift)
  end

  def edit(conn, %{"id" => id}) do
    gift = Gifts.get_gift!(id)
    changeset = Gifts.change_gift(gift)
    render(conn, "edit.html", gift: gift, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gift" => gift_params}) do
    gift = Gifts.get_gift!(id)

    case Gifts.update_gift(gift, gift_params) do
      {:ok, gift} ->
        conn
        |> put_flash(:info, "Gift updated successfully.")
        |> redirect(to: Routes.gift_path(conn, :show, gift))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", gift: gift, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gift = Gifts.get_gift!(id)
    {:ok, _gift} = Gifts.delete_gift(gift)

    conn
    |> put_flash(:info, "Gift deleted successfully.")
    |> redirect(to: Routes.gift_path(conn, :index))
  end
end
