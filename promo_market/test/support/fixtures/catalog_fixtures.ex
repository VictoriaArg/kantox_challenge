defmodule PromoMarket.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromoMarket.Catalog` context.
  """

  alias PromoMarket.Catalog.Product

  @doc """
  Generate a product.
  """
  @spec product_fixture(map()) :: Product.t()
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        code: "ABC10",
        description: "test product description",
        image_upload: "test_image_upload",
        name: "test product",
        price: Money.new(12, :GBP),
        stock: 42
      })
      |> PromoMarket.Catalog.create_product()

    product
  end

  def default_products_attrs() do
    [
      %{
        code: "CF1",
        name: "Arabica Coffee",
        description: "Arabica Coffee beans 250 grams",
        price: Money.new(1123, :GBP),
        stock: 45,
        image_upload:
          "https://kantoxchallenge.s3.us-east-1.amazonaws.com/products-images/coffee.jpg"
      },
      %{
        code: "SR1",
        name: "Strawberry",
        description: "Strawberry",
        price: Money.new(500, :GBP),
        stock: 324,
        image_upload:
          "https://kantoxchallenge.s3.us-east-1.amazonaws.com/products-images/strawberry.jpg"
      },
      %{
        code: "GR1",
        name: "Green Tea",
        description: "Chinese Green Tea",
        price: Money.new(311, :GBP),
        stock: 61,
        image_upload:
          "https://kantoxchallenge.s3.us-east-1.amazonaws.com/products-images/green_tea.jpg"
      }
    ]
  end
end
