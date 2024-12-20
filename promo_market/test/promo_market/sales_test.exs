defmodule PromoMarket.SalesTest do
  use PromoMarket.DataCase

  alias PromoMarket.Sales

  describe "promos" do
    alias PromoMarket.Sales.Promo

    import PromoMarket.SalesFixtures

    setup do
      promo = promo_fixture()

      invalid_attrs = %{
        active: true,
        name: "some name",
        discount_strategy: :some_discount_strategy,
        expiration_date: nil,
        stock_limit: -4
      }

      expiration_date = DateTime.utc_now() |> DateTime.add(10, :day)

      %{promo: promo, invalid_attrs: invalid_attrs, expiration_date: expiration_date}
    end

    test "list_promos/0 returns all promos", %{promo: promo} do
      assert Sales.list_promos() == [promo]
    end

    test "get_promo!/1 returns the promo with given id", %{promo: promo} do
      assert Sales.get_promo!(promo.id) == promo
    end

    test "create_promo/1 with valid data creates a promo", %{expiration_date: expiration_date} do
      valid_attrs = %{
        active: true,
        name: "some name",
        discount_strategy: :buy_one_get_one_free,
        expiration_date: expiration_date,
        stock_limit: 42
      }

      assert {:ok, %Promo{} = promo} = Sales.create_promo(valid_attrs)
      assert_promo_fields(promo, valid_attrs)
    end

    test "create_promo/1 with invalid data returns error changeset", %{
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Sales.create_promo(invalid_attrs)
    end

    test "update_promo/2 with valid data updates the promo", %{
      promo: promo,
      expiration_date: expiration_date
    } do
      update_attrs = %{
        active: false,
        name: "some updated name",
        discount_strategy: :buy_one_get_one_free,
        expiration_date: expiration_date,
        stock_limit: 42
      }

      assert {:ok, %Promo{} = promo} = Sales.update_promo(promo, update_attrs)
      assert_promo_fields(promo, update_attrs)
    end

    test "update_promo/2 with invalid data returns error changeset", %{
      promo: promo,
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Sales.update_promo(promo, invalid_attrs)
      assert promo == Sales.get_promo!(promo.id)
    end

    test "delete_promo/1 deletes the promo", %{promo: promo} do
      assert {:ok, %Promo{}} = Sales.delete_promo(promo)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_promo!(promo.id) end
    end

    test "change_promo/1 returns a promo changeset", %{promo: promo} do
      assert %Ecto.Changeset{} = Sales.change_promo(promo)
    end
  end

  defp assert_promo_fields(promo, attrs) do
    assert promo.active == attrs.active
    assert promo.name == attrs.name
    assert promo.discount_strategy == attrs.discount_strategy
    assert promo.stock_limit == attrs.stock_limit

    assert DateTime.truncate(promo.expiration_date, :second) ==
             DateTime.truncate(attrs.expiration_date, :second)
  end
end
