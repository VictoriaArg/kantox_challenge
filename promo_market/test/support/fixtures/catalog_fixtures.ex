defmodule PromoMarket.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromoMarket.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        code: "some code",
        description: "some description",
        image_upload: "some image_upload",
        name: "some name",
        price: 42,
        stock: 42
      })
      |> PromoMarket.Catalog.create_product()

    product
  end
end
