defmodule PromoMarket.Sales.DiscountStrategy do
  @moduledoc """
  Module for bussiness logic fuctions related to discounts for promos.
  """
  @strategies_codes [:buy_one_get_one_free, :bulk_purchase_price_drop]

  @spec strategies_codes() :: list()
  def strategies_codes(), do: @strategies_codes
end
