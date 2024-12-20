defmodule PromoMarket.CatalogTest do
  use PromoMarket.DataCase

  alias PromoMarket.Catalog

  describe "products" do
    alias PromoMarket.Catalog.Product

    import PromoMarket.CatalogFixtures

    @invalid_attrs %{code: nil, name: nil, description: nil, price: nil, stock: nil, image_upload: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{code: "some code", name: "some name", description: "some description", price: 42, stock: 42, image_upload: "some image_upload"}

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert product.code == "some code"
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.price == 42
      assert product.stock == 42
      assert product.image_upload == "some image_upload"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{code: "some updated code", name: "some updated name", description: "some updated description", price: 43, stock: 43, image_upload: "some updated image_upload"}

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert product.code == "some updated code"
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.price == 43
      assert product.stock == 43
      assert product.image_upload == "some updated image_upload"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
