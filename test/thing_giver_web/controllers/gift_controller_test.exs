defmodule ThingGiverWeb.GiftControllerTest do
  use ThingGiverWeb.ConnCase

  alias ThingGiver.Gifts

  @create_attrs %{giver: "some giver", receiver: "some receiver", thing: "some thing", verb: "some verb"}
  @update_attrs %{giver: "some updated giver", receiver: "some updated receiver", thing: "some updated thing", verb: "some updated verb"}
  @invalid_attrs %{giver: nil, receiver: nil, thing: nil, verb: nil}

  def fixture(:gift) do
    {:ok, gift} = Gifts.create_gift(@create_attrs)
    gift
  end

  describe "index" do
    test "lists all gifts", %{conn: conn} do
      conn = get(conn, Routes.gift_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Gifts"
    end
  end

  describe "new gift" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.gift_path(conn, :new))
      assert html_response(conn, 200) =~ "New Gift"
    end
  end

  describe "create gift" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.gift_path(conn, :create), gift: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.gift_path(conn, :show, id)

      conn = get(conn, Routes.gift_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Gift"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.gift_path(conn, :create), gift: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Gift"
    end
  end

  describe "edit gift" do
    setup [:create_gift]

    test "renders form for editing chosen gift", %{conn: conn, gift: gift} do
      conn = get(conn, Routes.gift_path(conn, :edit, gift))
      assert html_response(conn, 200) =~ "Edit Gift"
    end
  end

  describe "update gift" do
    setup [:create_gift]

    test "redirects when data is valid", %{conn: conn, gift: gift} do
      conn = put(conn, Routes.gift_path(conn, :update, gift), gift: @update_attrs)
      assert redirected_to(conn) == Routes.gift_path(conn, :show, gift)

      conn = get(conn, Routes.gift_path(conn, :show, gift))
      assert html_response(conn, 200) =~ "some updated giver"
    end

    test "renders errors when data is invalid", %{conn: conn, gift: gift} do
      conn = put(conn, Routes.gift_path(conn, :update, gift), gift: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Gift"
    end
  end

  describe "delete gift" do
    setup [:create_gift]

    test "deletes chosen gift", %{conn: conn, gift: gift} do
      conn = delete(conn, Routes.gift_path(conn, :delete, gift))
      assert redirected_to(conn) == Routes.gift_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.gift_path(conn, :show, gift))
      end
    end
  end

  defp create_gift(_) do
    gift = fixture(:gift)
    {:ok, gift: gift}
  end
end
