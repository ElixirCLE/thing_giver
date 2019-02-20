defmodule ThingGiver.GiftsTest do
  use ThingGiver.DataCase

  alias ThingGiver.Gifts

  describe "gifts" do
    alias ThingGiver.Gifts.Gift

    @valid_attrs %{giver: "some giver", receiver: "some receiver", thing: "some thing", verb: "some verb"}
    @update_attrs %{giver: "some updated giver", receiver: "some updated receiver", thing: "some updated thing", verb: "some updated verb"}
    @invalid_attrs %{giver: nil, receiver: nil, thing: nil, verb: nil}

    def gift_fixture(attrs \\ %{}) do
      {:ok, gift} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Gifts.create_gift()

      gift
    end

    test "list_gifts/0 returns all gifts" do
      gift = gift_fixture()
      assert Gifts.list_gifts() == [gift]
    end

    test "get_gift!/1 returns the gift with given id" do
      gift = gift_fixture()
      assert Gifts.get_gift!(gift.id) == gift
    end

    test "create_gift/1 with valid data creates a gift" do
      assert {:ok, %Gift{} = gift} = Gifts.create_gift(@valid_attrs)
      assert gift.giver == "some giver"
      assert gift.receiver == "some receiver"
      assert gift.thing == "some thing"
      assert gift.verb == "some verb"
    end

    test "create_gift/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gifts.create_gift(@invalid_attrs)
    end

    test "update_gift/2 with valid data updates the gift" do
      gift = gift_fixture()
      assert {:ok, %Gift{} = gift} = Gifts.update_gift(gift, @update_attrs)
      assert gift.giver == "some updated giver"
      assert gift.receiver == "some updated receiver"
      assert gift.thing == "some updated thing"
      assert gift.verb == "some updated verb"
    end

    test "update_gift/2 with invalid data returns error changeset" do
      gift = gift_fixture()
      assert {:error, %Ecto.Changeset{}} = Gifts.update_gift(gift, @invalid_attrs)
      assert gift == Gifts.get_gift!(gift.id)
    end

    test "delete_gift/1 deletes the gift" do
      gift = gift_fixture()
      assert {:ok, %Gift{}} = Gifts.delete_gift(gift)
      assert_raise Ecto.NoResultsError, fn -> Gifts.get_gift!(gift.id) end
    end

    test "change_gift/1 returns a gift changeset" do
      gift = gift_fixture()
      assert %Ecto.Changeset{} = Gifts.change_gift(gift)
    end
  end
end
