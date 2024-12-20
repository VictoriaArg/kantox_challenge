defmodule PromoMarket.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromoMarket.Catalog` context.
  """

  alias PromoMarket.Catalog.Product

  @doc """
  Generate a product.
  """
  @spec product_fixture(map()) :: %Product{}
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        code: "ABC10",
        description: "test product description",
        image_upload: "test_image_upload",
        name: "test product",
        price: Money.new(12, :EUR),
        stock: 42
      })
      |> PromoMarket.Catalog.create_product()

    product
  end
end
