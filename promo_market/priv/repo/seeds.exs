# # Script for populating the database. You can run it as:
# #
# #     mix run priv/repo/seeds.exs
if Mix.env() != :test do
  alias PromoMarket.Catalog
  alias PromoMarket.CatalogFixtures
  alias PromoMarket.Sales
  alias PromoMarket.SalesFixtures

  products = CatalogFixtures.default_products_attrs()

  [green_tea, strawberry, coffee] =
    Enum.reduce(products, [], fn attrs, acc ->
      {:ok, product} = Catalog.create_product(attrs)
      List.insert_at(acc, 0, product)
    end)

  promos = SalesFixtures.default_promos_params(green_tea.id, strawberry.id, coffee.id)

  Enum.each(promos, fn attrs -> Sales.create_promo(attrs) end)
end
