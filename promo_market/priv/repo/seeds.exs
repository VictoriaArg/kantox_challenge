# # Script for populating the database. You can run it as:
# #
# #     mix run priv/repo/seeds.exs

alias PromoMarket.Catalog
alias PromoMarket.Sales

products = [
  %{
    code: "CF1",
    name: "Arabica Coffee",
    description: "Arabica Coffee beans 250 grams",
    price: Money.new(11_23, :GBP),
    stock: 45,
    image_upload: "https://kantoxchallenge.s3.us-east-1.amazonaws.com/products-images/coffee.jpg"
  },
  %{
    code: "SR1",
    name: "Strawberry",
    description: "Strawberry",
    price: Money.new(5_00, :GBP),
    stock: 324,
    image_upload:
      "https://kantoxchallenge.s3.us-east-1.amazonaws.com/products-images/strawberry.jpg"
  },
  %{
    code: "GR1",
    name: "Green Tea",
    description: "Chinese Green Tea",
    price: Money.new(3_11, :GBP),
    stock: 61,
    image_upload:
      "https://kantoxchallenge.s3.us-east-1.amazonaws.com/products-images/green_tea.jpg"
  }
]

[green_tea, strawberry, coffee] =
  Enum.reduce(products, [], fn attrs, acc ->
    {:ok, product} = Catalog.create_product(attrs)
    List.insert_at(acc, 0, product)
  end)

expiration_date =
  DateTime.utc_now()
  |> DateTime.add(10, :day)

promos = [
  %{
    name: "challenge_promo",
    active: true,
    discount_strategy: :buy_one_get_one_free,
    expiration_date: expiration_date,
    stock_limit: 200,
    product_id: green_tea.id,
    min_units: 1
  },
  %{
    name: "challenge_promo",
    active: true,
    discount_strategy: :bulk_fixed_price_drop,
    expiration_date: expiration_date,
    stock_limit: 200,
    product_id: strawberry.id,
    min_units: 3
  },
  %{
    name: "challenge_promo",
    active: true,
    discount_strategy: :bulk_percentage_price_drop,
    expiration_date: expiration_date,
    stock_limit: 200,
    product_id: coffee.id,
    min_units: 3
  }
]

Enum.each(promos, fn attrs -> Sales.create_promo(attrs) end)
