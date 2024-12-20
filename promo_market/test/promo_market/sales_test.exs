defmodule PromoMarket.SalesTest do
  use PromoMarket.DataCase

  alias PromoMarket.Sales

  describe "promos" do
    alias PromoMarket.Sales.Promo

    import PromoMarket.SalesFixtures

    @invalid_attrs %{active: nil, name: nil, discount_strategy: nil, expiration_date: nil, stock_limit: nil}

    test "list_promos/0 returns all promos" do
      promo = promo_fixture()
      assert Sales.list_promos() == [promo]
    end

    test "get_promo!/1 returns the promo with given id" do
      promo = promo_fixture()
      assert Sales.get_promo!(promo.id) == promo
    end

    test "create_promo/1 with valid data creates a promo" do
      valid_attrs = %{active: true, name: "some name", discount_strategy: "some discount_strategy", expiration_date: ~U[2024-12-19 06:00:00Z], stock_limit: 42}

      assert {:ok, %Promo{} = promo} = Sales.create_promo(valid_attrs)
      assert promo.active == true
      assert promo.name == "some name"
      assert promo.discount_strategy == "some discount_strategy"
      assert promo.expiration_date == ~U[2024-12-19 06:00:00Z]
      assert promo.stock_limit == 42
    end

    test "create_promo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_promo(@invalid_attrs)
    end

    test "update_promo/2 with valid data updates the promo" do
      promo = promo_fixture()
      update_attrs = %{active: false, name: "some updated name", discount_strategy: "some updated discount_strategy", expiration_date: ~U[2024-12-20 06:00:00Z], stock_limit: 43}

      assert {:ok, %Promo{} = promo} = Sales.update_promo(promo, update_attrs)
      assert promo.active == false
      assert promo.name == "some updated name"
      assert promo.discount_strategy == "some updated discount_strategy"
      assert promo.expiration_date == ~U[2024-12-20 06:00:00Z]
      assert promo.stock_limit == 43
    end

    test "update_promo/2 with invalid data returns error changeset" do
      promo = promo_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_promo(promo, @invalid_attrs)
      assert promo == Sales.get_promo!(promo.id)
    end

    test "delete_promo/1 deletes the promo" do
      promo = promo_fixture()
      assert {:ok, %Promo{}} = Sales.delete_promo(promo)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_promo!(promo.id) end
    end

    test "change_promo/1 returns a promo changeset" do
      promo = promo_fixture()
      assert %Ecto.Changeset{} = Sales.change_promo(promo)
    end
  end
end
