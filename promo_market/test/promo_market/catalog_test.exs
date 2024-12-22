defmodule PromoMarket.CatalogTest do
  use PromoMarket.DataCase

  alias PromoMarket.Catalog

  describe "products" do
    alias PromoMarket.Catalog.Product
    import PromoMarket.CatalogFixtures

    setup do
      product = product_fixture()

      invalid_attrs =
        %{
          code: "ASDF1234",
          name: nil,
          description: nil,
          price: Money.new(0, :GBP),
          stock: -4,
          image_upload: 45
        }

      %{product: product, invalid_attrs: invalid_attrs}
    end

    test "list_products/0 returns all products", %{product: product} do
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id", %{product: product} do
      assert Catalog.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        code: "QW123",
        name: "some name",
        description: "some description",
        price: Money.new(2_50, :GBP),
        stock: 42,
        image_upload: "some_image_upload"
      }

      assert {:ok, %Product{} = product} = Catalog.create_product(valid_attrs)
      assert_product_fields(product, valid_attrs)
    end

    test "product code must be unique", %{product: product} do
      new_attrs = %{
        code: product.code,
        name: "some name",
        description: "some description",
        price: Money.new(2_50, :GBP),
        stock: 42,
        image_upload: "some_image_upload"
      }

      assert {:error, %Ecto.Changeset{errors: [code: {"has already been taken", _}]}} =
               Catalog.create_product(new_attrs)
    end

    test "get_product_by_code/1", %{product: product} do
      assert Catalog.get_product_by_code(product.code) == product
    end

    test "create_product/1 with invalid data returns error changeset", %{
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(invalid_attrs)
    end

    test "update_product/2 with valid data updates the product", %{product: product} do
      update_attrs = %{
        code: "ZXC321",
        name: "some updated name",
        description: "some updated description",
        price: Money.new(4, :GBP),
        stock: 43,
        image_upload: "some_updated_image_upload"
      }

      assert {:ok, %Product{} = product} = Catalog.update_product(product, update_attrs)
      assert_product_fields(product, update_attrs)
    end

    test "update_product/2 with invalid data returns error changeset", %{
      product: product,
      invalid_attrs: invalid_attrs
    } do
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, invalid_attrs)
      assert product == Catalog.get_product!(product.id)
    end

    test "delete_product/1 deletes the product", %{product: product} do
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset", %{product: product} do
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end

  defp assert_product_fields(product, attrs) do
    assert product.code == attrs.code
    assert product.name == attrs.name
    assert product.description == attrs.description
    assert product.price == attrs.price
    assert product.stock == attrs.stock
    assert product.image_upload == attrs.image_upload
  end
end
